module tests/safe011

open program
open model

/**
PPC safe011
"SyncdWW Rfe DpdW Wse"
Cycle=SyncdWW Rfe DpdW Wse
Relax=
Safe=Wse DpdW BCSyncdWW
{
0:r2=x; 0:r5=y;
1:r2=y; 1:r4=x;
}
 P0            | P1           ;
 lwz r1,0(r2)  | li r1,2      ;
 xor r3,r1,r1  | stw r1,0(r2) ;
 li r4,1       | sync         ;
 stwx r4,r3,r5 | li r3,1      ;
               | stw r3,0(r4) ;
exists
(y=2 /\ 0:r1=1)


**/


one sig x, y extends Location {}

one sig P1, P2 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Write {}
one sig op3 extends Write {}
one sig op4 extends Sync {}
one sig op5 extends Write {}

fact {
    P1.read[1, op1, x, 1]
    P1.write[2, op2, y, 1] and op2.dep[op1]
    P2.write[3, op3, y, 2]
    P2.sync[4, op4]
    P2.write[5, op5, x, 1]
}

fact {
    y.final[2]
}

Allowed:
    run { Allowed_PPC } for 4 int expect 0