document.getElementById("t1").addEventListener("click", removeTr);

function removeTr(e) {
	let trNode = e.target.parentNode;
	let parent = trNode.parentNode;

	parent.removeChild(trNode);
}
