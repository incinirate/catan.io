#![crate_type = "dylib"]

extern crate env_logger;
extern crate ws;

use std::boxed::Box;
use std::ffi::CStr;
use std::os::raw::c_char;
use std::sync::{Arc, Mutex};
use std::sync::{mpsc, mpsc::channel, mpsc::TryRecvError};
use std::thread;

use ws::{connect, Handler, Handshake, Message, Result, CloseCode};

struct Client {
    sender: mpsc::Sender<String>,
}

impl Handler for Client {
    fn on_open(&mut self, _: Handshake) -> Result<()> {
        // Do nothing
        Ok(())
    }

    fn on_message(&mut self, msg: Message) -> Result<()> {
        self.sender.send(msg.to_string()).unwrap();

        Ok(())
    }
}

fn extract_str(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr).to_string_lossy().into_owned() }
}

#[no_mangle]
pub extern "C" fn connect_ws(address: *const c_char) -> *mut (mpsc::Receiver<String>, mpsc::Sender<String>) {
    let url = extract_str(address);

    let (in_sender, in_receiver): (mpsc::Sender<String>, mpsc::Receiver<String>) = channel();
    let (out_sender, out_receiver): (mpsc::Sender<String>, mpsc::Receiver<String>) = channel();
    let result = Box::new((in_receiver, out_sender));
    let out_ref = Arc::new(Mutex::new(out_receiver));

    thread::spawn(move || connect(url, |out| {
        let o2 = out.clone();
        let out_ref = out_ref.clone();
        thread::spawn(move || {
            let inner = out_ref.clone();
            loop {
                let msg = inner.lock().unwrap().recv().ok().unwrap();
                match msg.as_ref() {
                    "disconnect" => {
                        o2.close(CloseCode::Normal).unwrap();
                        break;
                    }
                    _ => ()
                };

                match o2.send(msg) {
                    Ok(_) => true,
                    Err(_) => false
                };
            }
        });

        let c = Client { sender: in_sender.clone() };
        c
    }).unwrap());

    Box::into_raw(result)
}

#[no_mangle]
pub extern "C" fn poll_ws(receiver: *mut (mpsc::Receiver<String>, mpsc::Sender<String>)) -> *const u8 {
    let r_box = unsafe { Box::from_raw(receiver) };

    let mut r_str = match (*r_box).0.try_recv() {
        Ok(s) => s,
        Err(e) => {
            if e == TryRecvError::Disconnected { "disconnected".to_string() } else { "none".to_string() }
        }
    };

    Box::leak(r_box); // Make sure that Rust won't drop the receiver when we return

    r_str.push('\0');
    r_str.as_ptr()
}

#[no_mangle]
pub extern "C" fn send_ws(receiver: *mut (mpsc::Receiver<String>, mpsc::Sender<String>), message: *const c_char) -> bool {
    let r_box = unsafe { Box::from_raw(receiver) };
    let message = extract_str(message);

    let r = match (*r_box).1.send(message) {
        Ok(_) => true,
        Err(_) => false
    };

    Box::leak(r_box); // Make sure that Rust won't drop the receiver when we return

    r
}

#[no_mangle]
pub extern "C" fn destroy_ws(receiver: *mut (mpsc::Receiver<String>, mpsc::Sender<String>)) {
    let _r_box = unsafe { Box::from_raw(receiver) };
    // The receiver is now owned by this scope at this point and is thus dropped here
}
