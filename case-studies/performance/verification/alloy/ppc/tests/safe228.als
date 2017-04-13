module tests/safe228

open program
open model

/**
PPC safe228
"SyncdWR Fre SyncsWR Fre Rfe SyncdRW Wse"
Cycle=SyncdWR Fre SyncsWR Fre Rfe SyncdRW Wse
Relax=
Safe=Fre Wse SyncsWR SyncdWR ACSyncdRW
{
0:r2=x;
1:r2=x;
2:r2=x; 2:r4=y;
3:r2=y; 3:r4=x;
}
 P0           | P1           | P2           | P3           ;
 li r1,1      | li r1,2      | lwz r1,0(r2) | li r1,2      ;
 stw r1,0(r2) | stw r1,0(r2) | sync         | stw r1,0(r2) ;
 sync         |              | li r3,1      | sync         ;
 lwz r3,0(r2) |              | stw r3,0(r4) | lwz r3,0(r4) ;
exists
(x=2 /\ y=2 /\ 0:r3=1 /\ 2:r1=2 /\ 3:r3=0)


**/


one sig x, y extends Location {}

one sig P1, P2, P3, P4 extends Processor {}

one sig op1 extends Write {}
one sig op2 extends Sync {}
one sig op3 extends Read {}
one sig op4 extends Write {}
one sig op5 extends Read {}
one sig op6 extends Sync {}
one sig op7 extends Write {}
one sig op8 extends Write {}
one sig op9 extends Sync {}
one sig op10 extends Read {}

fact {
    P1.write[1, op1, x, 1]
    P1.sync[2, op2]
    P1.read[3, op3, x, 1]
    P2.write[4, op4, x, 2]
    P3.read[5, op5, x, 2]
    P3.sync[6, op6]
    P3.write[7, op7, y, 1]
    P4.write[8, op8, y, 2]
    P4.sync[9, op9]
    P4.read[10, op10, x, 0]
}

fact {
    y.final[2]
    x.final[2]
}

Allowed:
    run { Allowed_PPC } for 5 int expect 0