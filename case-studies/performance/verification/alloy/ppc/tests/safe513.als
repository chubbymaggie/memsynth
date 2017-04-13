module tests/safe513

open program
open model

/**
PPC safe513
"SyncdWW Rfe SyncdRW Rfe DpsR Fri Rfe SyncdRR Fre"
Cycle=SyncdWW Rfe SyncdRW Rfe DpsR Fri Rfe SyncdRR Fre
Relax=
Safe=Fri Fre DpsR ACSyncdRR BCSyncdWW BCSyncdRW
{
0:r2=x; 0:r4=y;
1:r2=y;
2:r2=y; 2:r4=z;
3:r2=z; 3:r4=x;
}
 P0           | P1            | P2           | P3           ;
 lwz r1,0(r2) | lwz r1,0(r2)  | lwz r1,0(r2) | li r1,1      ;
 sync         | xor r3,r1,r1  | sync         | stw r1,0(r2) ;
 li r3,1      | lwzx r4,r3,r2 | lwz r3,0(r4) | sync         ;
 stw r3,0(r4) | li r5,2       |              | li r3,1      ;
              | stw r5,0(r2)  |              | stw r3,0(r4) ;
exists
(y=2 /\ 0:r1=1 /\ 1:r1=1 /\ 1:r4=1 /\ 2:r1=2 /\ 2:r3=0)


**/


one sig x, y, z extends Location {}

one sig P1, P2, P3, P4 extends Processor {}

one sig op1 extends Read {}
one sig op2 extends Sync {}
one sig op3 extends Write {}
one sig op4 extends Read {}
one sig op5 extends Read {}
one sig op6 extends Write {}
one sig op7 extends Read {}
one sig op8 extends Sync {}
one sig op9 extends Read {}
one sig op10 extends Write {}
one sig op11 extends Sync {}
one sig op12 extends Write {}

fact {
    P1.read[1, op1, x, 1]
    P1.sync[2, op2]
    P1.write[3, op3, y, 1]
    P2.read[4, op4, y, 1]
    P2.read[5, op5, y, 1] and op5.dep[op4]
    P2.write[6, op6, y, 2]
    P3.read[7, op7, y, 2]
    P3.sync[8, op8]
    P3.read[9, op9, z, 0]
    P4.write[10, op10, z, 1]
    P4.sync[11, op11]
    P4.write[12, op12, x, 1]
}

fact {
    y.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0