module tests/safe238

open program
open model

/**
PPC safe238
"SyncdWW Rfe DpsR Fri Rfe SyncdRW Wse"
Cycle=SyncdWW Rfe DpsR Fri Rfe SyncdRW Wse
Relax=
Safe=Fri Wse DpsR ACSyncdRW BCSyncdWW
{
0:r2=x;
1:r2=x; 1:r4=y;
2:r2=y; 2:r4=x;
}
 P0            | P1           | P2           ;
 lwz r1,0(r2)  | lwz r1,0(r2) | li r1,2      ;
 xor r3,r1,r1  | sync         | stw r1,0(r2) ;
 lwzx r4,r3,r2 | li r3,1      | sync         ;
 li r5,2       | stw r3,0(r4) | li r3,1      ;
 stw r5,0(r2)  |              | stw r3,0(r4) ;
exists
(x=2 /\ y=2 /\ 0:r1=1 /\ 0:r4=1 /\ 1:r1=2)


**/


one sig x, y extends Location {}

one sig P1, P2, P3 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Read {}
one sig op3 extends Write {}
one sig op4 extends Read {}
one sig op5 extends Sync {}
one sig op6 extends Write {}
one sig op7 extends Write {}
one sig op8 extends Sync {}
one sig op9 extends Write {}

fact {
    P1.read[1, op1, x, 1]
    P1.read[2, op2, x, 1] and op2.dep[op1]
    P1.write[3, op3, x, 2]
    P2.read[4, op4, x, 2]
    P2.sync[5, op5]
    P2.write[6, op6, y, 1]
    P3.write[7, op7, y, 2]
    P3.sync[8, op8]
    P3.write[9, op9, x, 1]
}

fact {
    y.final[2]
    x.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0