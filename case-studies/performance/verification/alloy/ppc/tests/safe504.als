module tests/safe504

open program
open model

/**
PPC safe504
"LwSyncdWW Rfe SyncdRR Fre Rfe SyncdRR Fre"
Cycle=LwSyncdWW Rfe SyncdRR Fre Rfe SyncdRR Fre
Relax=
Safe=Fre LwSyncdWW ACSyncdRR
{
0:r2=x; 0:r4=y;
1:r2=y;
2:r2=y; 2:r4=z;
3:r2=z; 3:r4=x;
}
 P0           | P1           | P2           | P3           ;
 lwz r1,0(r2) | li r1,1      | lwz r1,0(r2) | li r1,1      ;
 sync         | stw r1,0(r2) | sync         | stw r1,0(r2) ;
 lwz r3,0(r4) |              | lwz r3,0(r4) | lwsync       ;
              |              |              | li r3,1      ;
              |              |              | stw r3,0(r4) ;
exists
(0:r1=1 /\ 0:r3=0 /\ 2:r1=1 /\ 2:r3=0)


**/


one sig x, y, z extends Location {}

one sig P1, P2, P3, P4 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Sync {}
one sig op3 extends Read {}
one sig op4 extends Write {}
one sig op5 extends Read {}
one sig op6 extends Sync {}
one sig op7 extends Read {}
one sig op8 extends Write {}
one sig op9 extends Lwsync {}
one sig op10 extends Write {}

fact {
    P1.read[1, op1, x, 1]
    P1.sync[2, op2]
    P1.read[3, op3, y, 0]
    P2.write[4, op4, y, 1]
    P3.read[5, op5, y, 1]
    P3.sync[6, op6]
    P3.read[7, op7, z, 0]
    P4.write[8, op8, z, 1]
    P4.lwsync[9, op9]
    P4.write[10, op10, x, 1]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0