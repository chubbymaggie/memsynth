module tests/safe385

open program
open model

/**
PPC safe385
"Rfe SyncdRW Rfe SyncsRR Fre SyncdWR Fre"
Cycle=Rfe SyncdRW Rfe SyncsRR Fre SyncdWR Fre
Relax=
Safe=Fre SyncdWR ACSyncsRR ACSyncdRW
{
0:r2=y; 0:r4=x;
1:r2=x;
2:r2=x; 2:r4=y;
3:r2=y;
}
 P0           | P1           | P2           | P3           ;
 lwz r1,0(r2) | lwz r1,0(r2) | li r1,2      | li r1,1      ;
 sync         | sync         | stw r1,0(r2) | stw r1,0(r2) ;
 li r3,1      | lwz r3,0(r2) | sync         |              ;
 stw r3,0(r4) |              | lwz r3,0(r4) |              ;
exists
(x=2 /\ 0:r1=1 /\ 1:r1=1 /\ 1:r3=1 /\ 2:r3=0)


**/


one sig x, y extends Location {}

one sig P1, P2, P3, P4 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Sync {}
one sig op3 extends Write {}
one sig op4 extends Read {}
one sig op5 extends Sync {}
one sig op6 extends Read {}
one sig op7 extends Write {}
one sig op8 extends Sync {}
one sig op9 extends Read {}
one sig op10 extends Write {}

fact {
    P1.read[1, op1, y, 1]
    P1.sync[2, op2]
    P1.write[3, op3, x, 1]
    P2.read[4, op4, x, 1]
    P2.sync[5, op5]
    P2.read[6, op6, x, 1]
    P3.write[7, op7, x, 2]
    P3.sync[8, op8]
    P3.read[9, op9, y, 0]
    P4.write[10, op10, y, 1]
}

fact {
    x.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0