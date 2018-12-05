var password = document.getElementById("password")
, password_c = document.getElementById("password_c");

function validatePassword()
{
   if(password.value != password_c.value) {
     password_c.setCustomValidity("Passwords Don't Match");
   } else {
     password_c.setCustomValidity('');
   }
}

password.onchange = validatePassword;
password_c.onkeyup = validatePassword;

