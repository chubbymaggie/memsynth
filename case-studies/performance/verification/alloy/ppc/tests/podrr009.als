module tests/podrr009

open program
open model

/**
PPC podrr009
"Fre SyncdWW Rfe SyncsRW Rfe PodRR"
Cycle=Fre SyncdWW Rfe SyncsRW Rfe PodRR
Relax=PodRR
Safe=Fre BCSyncsRW BCSyncdWW
{
0:r2=y; 0:r4=x;
1:r2=x;
2:r2=x; 2:r4=y;
}
 P0           | P1           | P2           ;
 li r1,1      | lwz r1,0(r2) | lwz r1,0(r2) ;
 stw r1,0(r2) | sync         | lwz r3,0(r4) ;
 sync         | li r3,2      |              ;
 li r3,1      | stw r3,0(r2) |              ;
 stw r3,0(r4) |              |              ;
exists
(x=2 /\ 1:r1=1 /\ 2:r1=2 /\ 2:r3=0)


**/


one sig x, y extends Location {}

one sig P1, P2, P3 extends Processor {}

one sig op1 extends Write {}
one sig op2 extends Sync {}
one sig op3 extends Write {}
one sig op4 extends Read {}
one sig op5 extends Sync {}
one sig op6 extends Write {}
one sig op7 extends Read {}
one sig op8 extends Read {}

fact {
    P1.write[1, op1, y, 1]
    P1.sync[2, op2]
    P1.write[3, op3, x, 1]
    P2.read[4, op4, x, 1]
    P2.sync[5, op5]
    P2.write[6, op6, x, 2]
    P3.read[7, op7, x, 2]
    P3.read[8, op8, y, 0]
}

fact {
    x.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 1