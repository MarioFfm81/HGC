function changeMatchday(ddBox){
	$("#ContentTable").hide();
	$(".previousResults").hide();
	document.location.href = ddBox.value;
}

function changeAdminUser(ddBox){
	document.location.href = ddBox.value;
}

function showLastResults(gameID){
	alert('hier');
	$(".previousResults").hide();
	$("#"+gameID).show();
}

$(window).load(function(){
	setTimeout(function(){
			$("#Flash").fadeOut();},5000);
});