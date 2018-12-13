/*NOTE: VARIABLE WERE NOT ALWAYS COOPERATIVE SO I DECIDED TO USE FULL PATHS INSTEADS.*/

var pict_array=["pict1.svg","pict2.png","pict3.png","pict4.png","pict5.png"];
var counter=0;
var len= document.getElementsByTagName('form');
var i;
var email=document.forms["sign_up_form"]["email"].value;
/*var phone_number= document.getElementsByName('phone_number').value;
var activation_code= document.getElementsByName('activation_code').value;
var broadband_number= document.getElementsByName('broadband_number').value;
*/
//home slide show
function rotate_picts() {
	document.getElementById("rotator").src="Assets/Images/"+pict_array[counter];
	counter++;
	setTimeout(rotate_picts,4000);
	if(counter==pict_array.length){
		counter=0;
	}
}
//out of stock items : index.html
function out_of_stock(){
	for (var i = 0; i < len.length; i++) {
		document.getElementsByClassName('buy_now')[i].innerHTML="Out of Stock";
		document.getElementsByClassName('buy_now')[i].classList.add("OutOfStock"); //see CSS
	}//end for
}//end function

//sign_up.html 

function sign_up(){
	//check for the first name
	if (document.forms["sign_up_form"]["firstname"].value ==""){
		document.getElementById("error1").innerHTML="*Please enter your firstname";
	}
	//check the lastname
	if (document.forms["sign_up_form"]["lastname"].value ==""){
		document.getElementById("error2").innerHTML="*Please enter your lastname";
	}
	//check for a numeric phone number and of 10 digits
	if(document.forms["sign_up_form"]["phone_number"].value.length !=10){
		document.getElementById("error4").innerHTML="*Please enter a valid phone number";
	}
	else if(isNaN(document.forms["sign_up_form"]["phone_number"].value*1)){
		document.getElementById("error4").innerHTML="*Please enter a valid phone number";
	}
	//numerical age or if empty.
	if(isNaN(document.forms["sign_up_form"]["date_of_birth"].value*1)){
		document.getElementById("error_age").innerHTML="*Please enter a valid age";
	}
	if(document.forms["sign_up_form"]["date_of_birth"].value==""){
		document.getElementById("error_age").innerHTML="*Please enter your age";
	}
	//check if country is selected
	if(document.getElementsByName("countries")[0].value == "select"){
		document.getElementById("error5").innerHTML="*Please select a Country";
	}
	//check if county is selected
	if(document.getElementsByName("county")[0].value == "select"){
		document.getElementById("error6").innerHTML="*Please select a County";
	}
	//matching passwords
	if(document.forms["sign_up_form"]["password1"].value!=document.forms["sign_up_form"]["password2"].value){
		document.getElementById("error7").innerHTML="*Passwords do not match";
	}
	//password must be entered
	if(document.forms["sign_up_form"]["password1"].value=="" && document.forms["sign_up_form"]["password2"].value==""){
		document.getElementById("error7").innerHTML="*You must enter a password";
	}
	//email must be valid
	email=document.forms["sign_up_form"]["email"].value;
	if((validate_email(email)==false)){
		document.getElementById("error3").innerHTML="*Please enter a valid e-mail";
	}
	return false;
}
//email validation function
function validate_email(email){
	var valid_format = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	return valid_format.test(email);
}
//******Activate sim card scripts***************
function activate_sim(){	
	if(document.forms["activate_my_sim_form"]["phone_number"].value== 0862233440 && document.forms["activate_my_sim_form"]["activation_code"].value== "XP54321"
		&& document.forms["activate_my_sim_form"]["broadband_number"].value==1234567890123456789){
		alert("Sucess! Your Sim Card has been activated.");
		return true;
	}
	else{
		document.getElementById("error8").innerHTML="Error !"+"<br>"+"The information entered does not match the card."+"<br>"+"Please Verify.";
	}
	
	return false;
}
//open the sample sim card to activate the sim
function open_sim_card(){
	document.getElementById('sim_card_info').style.display="block";
}
//close the sim card window
function close_sim_card(){
	document.getElementById('sim_card_info').style.display="none";
}


//*****************************add_to_Cart.html ***************************/

//1. hide & show additional infomation

function show_table(){
	document.getElementById('panel').style.display="block";
	document.getElementById('hide').style.display="inline-block";
}
function hide_table(){
	document.getElementById('panel').style.display="none";
	document.getElementById('hide').style.display="none";
}
//2. Submit order
function add_it(){
	alert("Item Added Sucessfully !");
}
//change image on click
function toute(){
	document.getElementById("front_image").src="Assets/Images/iphone1.png";
}
function rose_gold(){
	document.getElementById("front_image").src="Assets/Images/iphone2.png";
}
function silver(){
	document.getElementById("front_image").src="Assets/Images/iphone3.png";
}
//When hover on color option
function rose_color(){
	document.getElementById("colour_name").innerHTML="Rose-gold";
}
function gold_color(){
	document.getElementById("colour_name").innerHTML="Gold";
}
function silver_color(){
	document.getElementById("colour_name").innerHTML="Silver";
}
function space_grey_color(){
	document.getElementById("colour_name").innerHTML="Space Grey";
}
//When selecting the storage
function storage32(){
	document.getElementById("storage32").style.border="1px solid black";
	document.getElementById("storage128").style.borderTop="none";
	document.getElementById("storage128").style.borderLeft="none";
}
function storage128(){
	document.getElementById("storage128").style.border="1px solid black";
	document.getElementById("storage32").style.borderTop="none";
	document.getElementById("storage32").style.borderLeft="none";
}