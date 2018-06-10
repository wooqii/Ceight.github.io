f123();
console.log('A');
console.log('B');
f123();
console.log(1);
console.log(1);
console.log(1);
console.log(1);
console.log(1);
console.log(1);
f123();

function f123(){
    console.log(1);
    console.log(2);
    console.log(3);
}

console.log(Math.round(1.6)); //2
console.log(Math.round(1.4)); //1
 
function sum(first, second){ // parameter(매개변수)
  return first+second;
}
 
console.log(sum(2,4)); // argument(인자)