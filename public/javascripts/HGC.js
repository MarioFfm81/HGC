function changeMatchday(ddBox){
	$("#ContentTable").hide();
	document.location.href = ddBox.value;
}

function changeAdminUser(ddBox){
	document.location.href = ddBox.value;
}

$(window).load(function(){
	setTimeout(function(){
			$("#Flash").fadeOut();},5000);
});