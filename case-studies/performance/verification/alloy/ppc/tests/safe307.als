module tests/safe307

open program
open model

/**
PPC safe307
"SyncdWR Fre SyncsWW Rfe DpdR Fre"
Cycle=SyncdWR Fre SyncsWW Rfe DpdR Fre
Relax=
Safe=Fre SyncdWR DpdR BCSyncsWW
{
0:r2=x;
1:r2=x; 1:r5=y;
2:r2=y; 2:r4=x;
}
 P0           | P1            | P2           ;
 li r1,1      | lwz r1,0(r2)  | li r1,1      ;
 stw r1,0(r2) | xor r3,r1,r1  | stw r1,0(r2) ;
 sync         | lwzx r4,r3,r5 | sync         ;
 li r3,2      |               | lwz r3,0(r4) ;
 stw r3,0(r2) |               |              ;
exists
(x=2 /\ 1:r1=2 /\ 1:r4=0 /\ 2:r3=0)


**/


one sig x, y extends Location {}

one sig P1, P2, P3 extends Processor {}

one sig op1 extends Write {}
one sig op2 extends Sync {}
one sig op3 extends Write {}
one sig op4 extends Read {}
one sig op5 extends Read {}
one sig op6 extends Write {}
one sig op7 extends Sync {}
one sig op8 extends Read {}

fact {
    P1.write[1, op1, x, 1]
    P1.sync[2, op2]
    P1.write[3, op3, x, 2]
    P2.read[4, op4, x, 2]
    P2.read[5, op5, y, 0] and op5.dep[op4]
    P3.write[6, op6, y, 1]
    P3.sync[7, op7]
    P3.read[8, op8, x, 0]
}

fact {
    x.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0