cordova.define("br.com.paulobarbeiro.cddocument.CDDocument", function(require, exports, module) {
               
    //http://www.websector.de/blog/2013/07/25/example-of-a-native-ios-plugin-for-using-phonegap-3/
               
    var exec = require('cordova/exec');
/**
 * Constructor
 */
function CDDocument() {  }

CDDocument.prototype.sayHello = function() {
               
               
  exec(function(result){
      // result handler
      alert(result);
    },
    function(error){
      // error handler
      alert("Error" + error);
    }, 
    "CDDocument",
    "sayHello", 
    []
  );
}
               
CDDocument.prototype.startDatabase = function() {
               
    exec(function(result){
            // result handler
            alert(result);
            },
        function(error){
            // error handler
            alert("Error" + error);
            },
        "CDDocument",
        "startDatabase",
        []
        );
}
               
               CDDocument.prototype.getProjects = function(scope) {
               
               exec(function(result){
                    // result handler
                    //alert(result);
                    console.log("prototype.getProjects ===================== ");
                    //console.log( result );
                    //console.log( result.length );
                    //console.log("loop ----");
                    var preFriends = [];
                    for( var i=0 ; i<result.length ; i++){
                        //console.log("++");
                        //console.log(result[i]);
                        //console.log("id => "+result[i]['id']+", name =: "+result[i]['name']);
                        preFriends[i] = {id:result[i]['id'], name:result[i]['name']}
                    }
                    //preFriends[0] = {id:result.id, name:result.name};
                    //console.log("Scope -------------------");
                    //console.log(scope); //$scope not readable here
                    //console.log(scope.friends);
                    //console.log( typeof(scope.friends) );
                    scope.friends = preFriends;
                    return result;
                    },
                    function(error){
                    // error handler
                    alert("Error getProjects" + error);
                    },
                    "CDDocument",
                    "getProjects",
                    []
                    );
               }
               
               CDDocument.prototype.addProject = function(name) {
               
                    exec(function(result){
                         // result handler
                         //alert(result);
                         console.log("prototype.addProject==================");
                         //console.log(result);
                         //console.log(this);
                         //console.log(cdDocument);
                         //cdDocument.getProjects();
                         return result;
                         },
                         function(error){
                         // error handler
                         alert("Error addProject" + error);
                         },
                    "CDDocument",
                    "addProject",
                    [name]
                    );
               }

var cdDocument = new CDDocument();
module.exports = cdDocument

});
