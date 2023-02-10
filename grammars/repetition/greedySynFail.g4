grammar greedySynFail;

init : a b WS;

a: 'x'* 'x';

b: 'x';

WS : [\r\n]+ ;
