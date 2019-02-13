#![crate_type = "dylib"]

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}

extern crate env_logger;
extern crate ws;

use std::thread;
use ws::{connect, CloseCode};

#[no_mangle]
pub extern "C" fn foo() {
    println!("hey");
}

#[no_mangle]
pub extern "C" fn connect_ws(address: String) {
    thread::spawn(move || {
        env_logger::init();

        if let Err(error) = connect(address, |out| {
            // Queue a message to be sent when the WebSocket is open
            if out.send("Hello WebSocket").is_err() {
                println!("Websocket couldn't queue an initial message.")
            } else {
                println!("Client sent message 'Hello WebSocket'. ")
            }

            // The handler needs to take ownership of out, so we use move
            move |msg| {
                // Handle messages received on this connection
                println!("Client got message '{}'. ", msg);

                // Close the connection
                out.close(CloseCode::Normal)
            }
        }) {
            // Inform the user of failure
            println!("Failed to create WebSocket due to: {:?}", error);
        }
    });
}
