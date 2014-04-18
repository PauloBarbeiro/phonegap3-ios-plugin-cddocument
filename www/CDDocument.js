var exec = require('cordova/exec');
/**
 * Constructor
 */
function CDDocument() {}

CDDocument.prototype.sayHello = function() {
  exec(function(result){
      // result handler
      alert(result);
    },
    function(error){
      // error handler
      alert("Error" + error);
    }, 
    "MyPlugin", 
    "sayHello", 
    []
  );
}

var cdDocument = new CDDocument();
module.exports = cdDocument