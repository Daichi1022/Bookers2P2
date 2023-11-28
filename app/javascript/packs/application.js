// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 

// レビュー機能　　raty.jsというJavaScriptライブラリからRatyというオブジェクトをインポートして、グローバル変数のwindow.ratyに設定しているもの。画面上に表示されているすべてのオブジェクトの親となるオブジェクト,JavaScriptのオブジェクト階層の最上位に位置する
import Raty from "raty.js"      
window.raty = function(elem,opt){
    var raty =  new Raty(elem,opt)
    raty.init();
    return raty;
}


Rails.start()
Turbolinks.start()
ActiveStorage.start()
