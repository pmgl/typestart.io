// Generated by CoffeeScript 1.8.0
new Command({
  name: "pass",
  init: function() {
    return $.getScript("https://crypto-js.googlecode.com/svn/tags/3.1.2/build/rollups/sha3.js");
  },
  f: function(arg) {
    var cryptophrase, getPass, s;
    s = typestart.splitArg(arg);
    cryptophrase;
    getPass = function(service) {
      var pass;
      pass = btoa(CryptoJS.SHA3(cryptophrase + service).toString()).substring(0, 32);
      return typestart.echo(pass);
    };
    switch (s.length) {
      case 0:
        return "Usage: pass <your_service>";
      case 1:
        cryptophrase = sessionStorage.getItem("pass_cryptophrase");
        if (!cryptophrase) {
          typestart.terminal.set_mask(true);
          typestart.terminal.read("enter your passphrase > ", function(result) {
            var x;
            typestart.terminal.set_mask(false);
            cryptophrase = result;
            x = 0;
            while (x < 1000) {
              cryptophrase = CryptoJS.SHA3(cryptophrase).toString();
              x++;
            }
            sessionStorage.setItem("pass_cryptophrase", cryptophrase);
            return getPass(s[0]);
          });
        } else {
          getPass(s[0]);
        }
        return void 0;
    }
  }
});
