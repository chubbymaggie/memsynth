module tests/safe070

open program
open model

/**
PPC safe070
"LwSyncdWW Wse SyncdWR Fre SyncdWW Wse"
Cycle=LwSyncdWW Wse SyncdWR Fre SyncdWW Wse
Relax=
Safe=Fre Wse SyncdWW SyncdWR LwSyncdWW
{
0:r2=x; 0:r4=y;
1:r2=y; 1:r4=z;
2:r2=z; 2:r4=x;
}
 P0           | P1           | P2           ;
 li r1,2      | li r1,1      | li r1,2      ;
 stw r1,0(r2) | stw r1,0(r2) | stw r1,0(r2) ;
 sync         | sync         | lwsync       ;
 lwz r3,0(r4) | li r3,1      | li r3,1      ;
              | stw r3,0(r4) | stw r3,0(r4) ;
exists
(x=2 /\ z=2 /\ 0:r3=0)


**/


one sig x, y, z extends Location {}

one sig P1, P2, P3 extends Processor {}

one sig op1 extends Write {}
one sig op2 extends Sync {}
one sig op3 extends Read {}
one sig op4 extends Write {}
one sig op5 extends Sync {}
one sig op6 extends Write {}
one sig op7 extends Write {}
one sig op8 extends Lwsync {}
one sig op9 extends Write {}

fact {
    P1.write[1, op1, x, 2]
    P1.sync[2, op2]
    P1.read[3, op3, y, 0]
    P2.write[4, op4, y, 1]
    P2.sync[5, op5]
    P2.write[6, op6, z, 1]
    P3.write[7, op7, z, 2]
    P3.lwsync[8, op8]
    P3.write[9, op9, x, 1]
}

fact {
    x.final[2]
    z.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0