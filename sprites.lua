local _ = require("lib.luascore")
local util = require("util")

local rock = {{15.215311004784,4.7368421052633,11.770334928229,5.5980861244021,6.4593301435401,-21.387559808613,13.492822966507,-22.966507177034,26.267942583732,-11.196172248804,23.54066985646,-6.746411483254,30,9,22.105263157895,19.952153110048,15.215311004784,4.7368421052633,17.655502392344,-3.8755980861242,23.54066985646,-6.746411483254},{26.267942583732,-11.196172248804,30,9},{6.4593301435401,-21.387559808613,-12.631578947368,-28.277511961722,-18.803827751197,-30,-24.688995215311,-20.526315789474,-26.124401913876,-13.062200956938,-28.708133971292,-10.334928229665,-30,-4.019138755981,-26.267942583732,0.43062200956955,-21.53110047847,18.22966507177,-10.047846889952,30,0.14354066985615,28.277511961722,6.8899521531095,29.856459330143,22.105263157895,19.952153110048},{6.8899521531095,29.856459330143,11.770334928229,5.5980861244021,-0.71770334928262,-0.86124401913859,-4.593301435407,4.8803827751192,0.14354066985615,28.277511961722,-16.65071770335,17.511961722488,-21.53110047847,18.22966507177},{-0.71770334928262,-0.86124401913859,-7.0334928229666,-15.071770334928,-12.631578947368,-28.277511961722},{-16.65071770335,17.511961722488,-7.0334928229666,-15.071770334928},}
local wheat = {{-3.75,-8.8636363636364,-4.0909090909091,-12.272727272727,0,-19.090909090909,4.0909090909091,-12.272727272727,3.75,-8.8636363636364,2.7272727272727,-5.4545454545455,0,-1.3636363636364,-2.7272727272727,-5.4545454545455,-3.75,-8.8636363636364},{1.3636363636364,-28.636363636364,2.7272727272727,-30,4.0909090909091,-28.636363636364,4.0909090909091,-17.045454545455,1.3636363636364,-21.136363636364,1.3636363636364,-28.636363636364},{-2.7272727272727,-30,-1.3636363636364,-28.636363636364,-1.3636363636364,-21.136363636364,-4.0909090909091,-17.045454545455,-4.0909090909091,-28.636363636364,-2.7272727272727,-30},{-6.8181818181818,-9.5454545454545,-6.8181818181818,-25.909090909091,-8.1818181818182,-27.272727272727,-9.5454545454545,-25.909090909091,-9.5454545454545,-11.590909090909,-6.8181818181818,-9.5454545454545},{-15,-12.954545454545,-12.272727272727,-12.272727272727,-12.272727272727,-21.818181818182,-13.636363636364,-23.181818181818,-15,-21.818181818182,-15,-12.954545454545},{-1.3636363636364,1.3636363636364,-2.7272727272727,-2.0454545454545,-5.4545454545455,-6.1363636363636,-10.227272727273,-9.5454545454545,-15,-10.909090909091,-14.318181818182,-6.8181818181818,-12.272727272727,-2.0454545454545,-7.5,1.3636363636364,-1.3636363636364,4.0909090909091,-1.3636363636364,6.8181818181818},{-1.3636363636364,13.636363636364,-3.4090909090909,7.5,-7.5,3.4090909090909,-15,0,-14.318181818182,6.8181818181818,-12.272727272727,10.909090909091,-7.5,15,-1.3636363636364,16.363636363636,-1.3636363636364,25.909090909091,0,30,1.3636363636364,25.909090909091,1.3636363636364,16.363636363636,7.5,15,12.272727272727,10.909090909091,14.318181818182,6.8181818181818,15,0,7.5,3.4090909090909,3.4090909090909,7.5,1.3636363636364,13.636363636364},{1.3636363636364,6.8181818181818,1.3636363636364,4.0909090909091,7.5,1.3636363636364,12.272727272727,-2.0454545454545,14.318181818182,-6.8181818181818,15,-10.909090909091,10.227272727273,-9.5454545454545,5.4545454545455,-6.1363636363636,2.7272727272727,-2.0454545454545,1.3636363636364,1.3636363636364},{8.1818181818182,-27.272727272727,6.8181818181818,-25.909090909091,6.8181818181818,-9.5454545454545,9.5454545454545,-11.590909090909,9.5454545454545,-25.909090909091,8.1818181818182,-27.272727272727},{12.272727272727,-12.272727272727,12.272727272727,-21.818181818182,13.636363636364,-23.181818181818,15,-21.818181818182,15,-12.954545454545,12.272727272727,-12.272727272727},}
local brick = {{-1.25,-1,-8.375,-1.5,-20.07012195122,3.9227642276423,-16.492886178862,5.2235772357724,-1.25,-1,1.0680894308943,-0.7926829268293,0.7428861788618,-12.337398373984,-12.427845528455,-13.150406504065,-12.265243902439,-3.2317073170732,-12.102642276423,-1.6056910569106,-8.375,-1.5},{14.889227642276,-8.9227642276423,23.019308943089,-6.1585365853659,25.375,-7.375,16.875,-10.125,14.889227642276,-8.9227642276423,11.637195121951,-6.9715447154472,22.531504065041,-3.2317073170732,32.125,-7.5,32.125,1.5,22.625,6,12.125,2.6219512195122,11.962398373984,-4.0447154471545,8.5477642276423,-5.1829268292683,1.0680894308943,-0.7926829268293},{6.5965447154472,-20.467479674797,10.336382113821,-20.467479674797,12.287601626016,-21.768292682927,6.5965447154472,-22.093495934959,-6.2489837398374,-14.776422764228,-3.9725609756098,-14.613821138211,6.5965447154472,-20.467479674797,6.5965447154472,-22.093495934959},{10.336382113821,-20.467479674797,0.4176829268293,-14.288617886179,-3.9725609756098,-14.613821138211},{25.375,-7.375,26.375,-8,17.875,-10.75,19.375,-11.75,32.125,-7.5},{17.875,-10.75,16.875,-10.125},{-12.427845528455,-13.150406504065,6.1087398373984,-24.532520325203,19.116869918699,-23.556910569106,19.375,-11.75},{19.116869918699,-23.556910569106,0.7428861788618,-12.337398373984},{11.962398373984,-4.0447154471545,-16.818089430894,7.987804878049,-27.875,3.5,-12.265243902439,-3.2317073170732},{11.637195121951,-6.9715447154472,8.5477642276423,-5.1829268292683},{22.625,6,22.531504065041,-3.2317073170732},{-12.102642276423,-1.6056910569106,-21.858739837398,3.109756097561,-20.07012195122,3.9227642276423},{12.125,2.6219512195122,12.125,6.849593495935,-16.980691056911,19.532520325203,-27.875,15,-27.875,3.5},{-16.980691056911,19.532520325203,-16.818089430894,7.987804878049},}
local wood = {{9.0430622009569,-18.22966507177,7.6076555023923,-11.913875598086},{-3.0143540669856,-19.952153110048,-4.4497607655502,-14.210526315789},{18.22966507177,-18.803827751196,17.081339712919,-14.210526315789},{1.0047846889952,-8.4688995215311,0.43062200956938,-0.43062200956938},{-14.210526315789,-23.684210526316,-15.071770334928,-20.526315789474},{0.14354066985646,2.7272727272727,26.555023923445,-19.090909090909,-20.526315789474,-25.406698564593,0.14354066985646,2.7272727272727},{-23.11004784689,-9.6172248803828,-16.507177033493,-8.755980861244},{-24.545454545455,-18.803827751196,-22.248803827751,-18.516746411483},{-26.842105263158,0.7177033492823,-22.535885167464,1.0047846889952},{-11.913875598086,1.5789473684211,-7.3205741626794,2.1531100478469},{-25.11961722488,-25.406698564593,-3.0143540669856,4.4497607655502,-28.851674641148,3.3014354066986,-25.11961722488,-25.406698564593},{21.674641148325,-3.8755980861244,17.081339712919,-0.14354066985646},{26.555023923445,-12.488038277512,22.535885167464,-8.755980861244},{10.191387559809,1.0047846889952,7.6076555023923,3.0143540669856},{24.545454545455,0.43062200956938,20.526315789474,3.8755980861244},{21.674641148325,6.4593301435407,2.7272727272727,4.7368421052632,29.138755980861,-16.507177033493,26.555023923445,2.4401913875598,21.674641148325,6.4593301435407},{20.526315789474,15.358851674641,21.1004784689,19.665071770335},{26.842105263158,17.081339712919,27.416267942584,20.239234449761},{13.349282296651,18.803827751196,13.923444976077,21.674641148325},{25.406698564593,8.755980861244,25.980861244019,12.775119617225},{26.842105263158,5.0239234449761,6.4593301435407,23.397129186603,30,21.961722488038,26.842105263158,5.0239234449761},{-22.248803827751,18.516746411483,-17.655502392344,21.674641148325},{-1.866028708134,12.200956937799,2.7272727272727,14.497607655502},{9.6172248803828,10.765550239234,12.775119617225,12.200956937799},{-1.0047846889952,17.081339712919,2.1531100478469,19.090909090909},{-27.129186602871,11.626794258373,-23.11004784689,13.923444976077},{-28.564593301435,22.535885167464,-27.129186602871,23.684210526316},{-9.6172248803828,21.387559808612,-6.1722488038278,23.11004784689},{-18.22966507177,8.1818181818182,-13.923444976077,10.478468899522},{-25.693779904306,6.1722488038277,3.0143540669856,22.535885167464,18.516746411483,9.3301435406699,-25.693779904306,6.1722488038277},{-30,25.406698564593,0.43062200956938,24.545454545455,-29.138755980861,7.8947368421053,-30,25.406698564593},}
local wool = {{-15.625,-11.875,-18.125,-8.75,-19.375,-4.375,-20,3.125,-17.5,10,-13.75,13.125,-8.75,15,0.625,15.625,6.875,15,10.625,13.75,13.125,10.625,14.375,7.5,15,2.5,14.375,-0.625,12.5,-5,8.125,-8.75,1.875,-9.375,-4.375,-8.75,-10,-6.25,-13.75,-0.625,-14.375,5,-12.5,10.625,-9.375,13.75,0,18.125,6.25,19.375,13.75,18.75,16.875,16.25,18.75,12.5,20,7.5,20,1.875,18.75,-5,16.875,-8.75,14.375,-11.25,12.5,-12.5,10.625,-13.75,8.75,-15.625,8.75,-17.5,10,-19.375,12.5,-19.375,14.375,-17.5},}
local desert = {{22,-22,-22,22},{22,22,-22,-22},}

return {
    resources = _.zipOnKey({ rock  = rock
                           , wood  = wood
                           , wool  = wool
                           , wheat = wheat
                           , brick = brick
                           , desert = desert },
                           { rock   = { bg = util.rgb(44 , 44 , 84 ), fg = util.rgb(112, 111, 211) }
                           , wood   = { bg = util.rgb(23 , 99 , 82 ), fg = util.rgb(129, 236, 236) }-- util.rgb(43 , 29 , 14 ) }
                           , wool   = { bg = util.rgb(0  , 0  , 0  ), fg = util.rgb(255, 255, 255) }
                           , wheat  = { bg = util.rgb(255, 121, 63 ), fg = util.rgb(255, 218, 121) }
                           , brick  = { bg = util.rgb(179, 57 , 57 ), fg = util.rgb(255, 218, 121) }
                           , desert = { bg = util.rgb(241, 196, 15 ), fg = util.rgb(255, 255, 255) } })
}
