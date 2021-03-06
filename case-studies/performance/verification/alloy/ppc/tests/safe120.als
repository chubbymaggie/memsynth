module tests/safe120

open program
open model

/**
PPC safe120
"SyncdWW Rfe DpsR Fre SyncdWW Rfe SyncdRW Wse"
Cycle=SyncdWW Rfe DpsR Fre SyncdWW Rfe SyncdRW Wse
Relax=
Safe=Fre Wse SyncdRW DpsR BCSyncdWW
{
0:r2=x;
1:r2=x; 1:r4=y;
2:r2=y; 2:r4=z;
3:r2=z; 3:r4=x;
}
 P0            | P1           | P2           | P3           ;
 lwz r1,0(r2)  | li r1,2      | lwz r1,0(r2) | li r1,2      ;
 xor r3,r1,r1  | stw r1,0(r2) | sync         | stw r1,0(r2) ;
 lwzx r4,r3,r2 | sync         | li r3,1      | sync         ;
               | li r3,1      | stw r3,0(r4) | li r3,1      ;
               | stw r3,0(r4) |              | stw r3,0(r4) ;
exists
(x=2 /\ z=2 /\ 0:r1=1 /\ 0:r4=1 /\ 2:r1=1)


**/


one sig x, y, z extends Location {}

one sig P1, P2, P3, P4 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Read {}
one sig op3 extends Write {}
one sig op4 extends Sync {}
one sig op5 extends Write {}
one sig op6 extends Read {}
one sig op7 extends Sync {}
one sig op8 extends Write {}
one sig op9 extends Write {}
one sig op10 extends Sync {}
one sig op11 extends Write {}

fact {
    P1.read[1, op1, x, 1]
    P1.read[2, op2, x, 1] and op2.dep[op1]
    P2.write[3, op3, x, 2]
    P2.sync[4, op4]
    P2.write[5, op5, y, 1]
    P3.read[6, op6, y, 1]
    P3.sync[7, op7]
    P3.write[8, op8, z, 1]
    P4.write[9, op9, z, 2]
    P4.sync[10, op10]
    P4.write[11, op11, x, 1]
}

fact {
    x.final[2]
    z.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0