//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

var workbook = null;

function parseExcel(input){
    console.log("parseexcel");
    var reader = new FileReader();
    
    reader.onload = function(e){
        workbook = XLS.read(e.target.result, {type: "binary"});
        console.log("loaded workbook");
    }
    
    reader.readAsBinaryString(input);
}

$(document).ready(function(){
$("#roster_file").change(function(){
    console.log("changed");
    if (this.files && this.files[0] && this.value.substr(-4) == ".xls"){
        parseExcel(this.files[0]);
    } 
    if (!(this.value.substr(-4) == ".xls")){
        alert("Please insert a valid '.xls' file (that's the default downloaded one).");
    }
})
})
//var workbook = XLS.read((new FileReader()).readAsBinaryString($("#roster_file")[0].files[0]), {type: "binary"});
