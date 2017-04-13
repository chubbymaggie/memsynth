module tests/safe131

open program
open model

/**
PPC safe131
"SyncdWW Rfe SyncdRW Rfe SyncdRW Wse"
Cycle=SyncdWW Rfe SyncdRW Rfe SyncdRW Wse
Relax=
Safe=Wse SyncdRW BCSyncdWW BCSyncdRW
{
0:r2=x; 0:r4=y;
1:r2=y; 1:r4=z;
2:r2=z; 2:r4=x;
}
 P0           | P1           | P2           ;
 lwz r1,0(r2) | lwz r1,0(r2) | li r1,2      ;
 sync         | sync         | stw r1,0(r2) ;
 li r3,1      | li r3,1      | sync         ;
 stw r3,0(r4) | stw r3,0(r4) | li r3,1      ;
              |              | stw r3,0(r4) ;
exists
(z=2 /\ 0:r1=1 /\ 1:r1=1)


**/


one sig x, y, z extends Location {}

one sig P1, P2, P3 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Sync {}
one sig op3 extends Write {}
one sig op4 extends Read {}
one sig op5 extends Sync {}
one sig op6 extends Write {}
one sig op7 extends Write {}
one sig op8 extends Sync {}
one sig op9 extends Write {}

fact {
    P1.read[1, op1, x, 1]
    P1.sync[2, op2]
    P1.write[3, op3, y, 1]
    P2.read[4, op4, y, 1]
    P2.sync[5, op5]
    P2.write[6, op6, z, 1]
    P3.write[7, op7, z, 2]
    P3.sync[8, op8]
    P3.write[9, op9, x, 1]
}

fact {
    z.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0