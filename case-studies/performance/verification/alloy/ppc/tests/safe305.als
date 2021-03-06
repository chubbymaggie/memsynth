module tests/safe305

open program
open model

/**
PPC safe305
"SyncsWW Rfe DpdR Fre SyncsWW Rfe DpdR Fre"
Cycle=SyncsWW Rfe DpdR Fre SyncsWW Rfe DpdR Fre
Relax=
Safe=Fre DpdR BCSyncsWW
{
0:r2=y; 0:r5=x;
1:r2=x;
2:r2=x; 2:r5=y;
3:r2=y;
}
 P0            | P1           | P2            | P3           ;
 lwz r1,0(r2)  | li r1,1      | lwz r1,0(r2)  | li r1,1      ;
 xor r3,r1,r1  | stw r1,0(r2) | xor r3,r1,r1  | stw r1,0(r2) ;
 lwzx r4,r3,r5 | sync         | lwzx r4,r3,r5 | sync         ;
               | li r3,2      |               | li r3,2      ;
               | stw r3,0(r2) |               | stw r3,0(r2) ;
exists
(x=2 /\ y=2 /\ 0:r1=2 /\ 0:r4=0 /\ 2:r1=2 /\ 2:r4=0)


**/


one sig x, y extends Location {}

one sig P1, P2, P3, P4 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Read {}
one sig op3 extends Write {}
one sig op4 extends Sync {}
one sig op5 extends Write {}
one sig op6 extends Read {}
one sig op7 extends Read {}
one sig op8 extends Write {}
one sig op9 extends Sync {}
one sig op10 extends Write {}

fact {
    P1.read[1, op1, y, 2]
    P1.read[2, op2, x, 0] and op2.dep[op1]
    P2.write[3, op3, x, 1]
    P2.sync[4, op4]
    P2.write[5, op5, x, 2]
    P3.read[6, op6, x, 2]
    P3.read[7, op7, y, 0] and op7.dep[op6]
    P4.write[8, op8, y, 1]
    P4.sync[9, op9]
    P4.write[10, op10, y, 2]
}

fact {
    y.final[2]
    x.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0