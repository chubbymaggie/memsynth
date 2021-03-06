module tests/bclwdww007

open program
open model

/**
PPC bclwdww007
"DpdW Wse LwSyncdWW Wse LwSyncdWW Rfe"
Cycle=DpdW Wse LwSyncdWW Wse LwSyncdWW Rfe
Relax=BCLwSyncdWW
Safe=Wse LwSyncdWW DpdW
{
0:r2=x; 0:r4=y;
1:r2=y; 1:r4=z;
2:r2=z; 2:r5=x;
}
 P0           | P1           | P2            ;
 li r1,2      | li r1,2      | lwz r1,0(r2)  ;
 stw r1,0(r2) | stw r1,0(r2) | xor r3,r1,r1  ;
 lwsync       | lwsync       | li r4,1       ;
 li r3,1      | li r3,1      | stwx r4,r3,r5 ;
 stw r3,0(r4) | stw r3,0(r4) |               ;
exists
(x=2 /\ y=2 /\ 2:r1=1)


**/


one sig x, y, z extends Location {}

one sig P1, P2, P3 extends Processor {}

one sig op1 extends Write {}
one sig op2 extends Lwsync {}
one sig op3 extends Write {}
one sig op4 extends Write {}
one sig op5 extends Lwsync {}
one sig op6 extends Write {}
one sig op7 extends Read {}
one sig op8 extends Write {}

fact {
    P1.write[1, op1, x, 2]
    P1.lwsync[2, op2]
    P1.write[3, op3, y, 1]
    P2.write[4, op4, y, 2]
    P2.lwsync[5, op5]
    P2.write[6, op6, z, 1]
    P3.read[7, op7, z, 1]
    P3.write[8, op8, x, 1] and op8.dep[op7]
}

fact {
    y.final[2]
    x.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 1