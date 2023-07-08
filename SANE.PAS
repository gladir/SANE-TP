{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/sane-tp)
  @abstract(Target: Turbo Pascal 7, Free Pascal)
  @Description: Clone de SANE (Standard Apple Numeric Environment) en Turbo Pascal
}

Unit SANE;

{$N+}

INTERFACE

Const
 DecStrLen=255;
 SigDigLen=20; { Pour les 68K; utilis‚ 28 dans 6502 SANE }
  {Les exceptions}
 Invalid=1;
 Underflow=2;
 Overflow=4;
 DivByZero=8;
 Inexact=16;

Type
  {Type pour la gestion des repr‚sentations d‚cimales }
 DecStr=String[DecStrLen];
 CStrPtr=^Char;
 Decimal=Record
  Sgn:0..1;
  Exp:integer;
  Sig:String[SigDigLen]
 End;

 DecForm=Record
  Style:(FloatDecimal,FixedDecimal);
  Digits:Integer;
 End;

  {Relations d'ordonnation }
 RelOp=(GreaterThan,LessThan,EqualTo,Unordered);
  {Classe d'enquˆtes}
 NumClass = (SNaN,QNaN,Infinite,ZeroNum,NormalNum,DenormalNum);
  {Contr“le d'environnement }
 Exception=Integer;
 RoundDir=(ToNearest,Upward,Downward,TowardZero);
 RoundPre=(ExtPrecision,DblPrecision,RealPrecision);
 Environment=Integer;

 (* Fonctions et proc‚dures de la bibliothŠque SANE *)

  {Conversion entre des types num‚riques binaires }
Function Num2Integer(X:extended):Integer;
Function Num2Longint(X:extended):LongInt;
Function Num2Real(X:Extended):Real;
Function Num2Double(X:Extended):Double;
Function Num2Extended(X:Extended):Extended;
Function Num2Comp(X:Extended):Comp;

 {Conversion entre binaire et d‚cimal }
Procedure Num2Dec(f:DecForm;x:extended;Var d:Decimal);
Function Dec2Num(d:Decimal):Extended;
Procedure Num2Str(f:DecForm;x:Extended;Var s:DecStr);
Function Str2Num(s:DecStr):Extended;

 {Conversion entre des formats d‚cimal }
Procedure Str2Dec(s:DecStr;Var Index:Integer;Var d:Decimal;Var ValidPrefix:Boolean);
Procedure CStr2Dec(s:CStrPtr;Var Index:Integer;Var d:Decimal;Var ValidPrefix:Boolean);
Procedure Dec2Str(f:DecForm;d:Decimal;Var s:DecStr);

 {Fonctions arithm‚tique, auxilaire et ‚l‚mentaire }
Function Remainder(x,y:Extended;Var Quo:Integer):Extended;
Function Rint(x:Extended):Extended;
Function Scalb(n:Integer;x:Extended):Extended;
Function Logb(x:Extended):Extended;
Function CopySign(x,y:Extended):Extended;
Function NextReal(x,y:Real):Real;
Function NextDouble(x,y:Double):Double;
Function NextExtended(x,y:Extended):Extended;
Function Log2(x:Extended):Extended;
Function Ln1(x:Extended):Extended;
Function Exp2(x:Extended):Extended;
Function Exp1(x:Extended):Extended;
Function XpwrI(x:Extended;i:Integer):Extended;
Function XpwrY(x,y:Extended):Extended;
Function Compound(r,n:Extended):Extended;
Function Annuity(r,n:Extended):Extended;
Function Tan(x:Extended):Extended;
Function RandomX(Var x:Extended):Extended;

 {Routines d'enquˆtes}
Function ClassReal(x:Real):NumClass;
Function ClassDouble(x:Double):NumClass;
Function ClassComp(x:Comp):NumClass;
Function ClassExtended(x:Extended):NumClass;
Function SignNum(x:Extended ):Integer;
Function NAN(i:Integer):Extended;

 {Routines d'accŠs d'environnement}
Procedure SetException(e:Exception;b:Boolean);
Function TestException(e:Exception):Boolean;
Procedure SetHalt(e:Exception;b:Boolean);
Function TestHalt(e:Exception):Boolean;
Procedure SetRound(r:RoundDir);
Function GetRound:RoundDir;
Procedure SetPrecision(p:RoundPre);
Function GetPrecision:RoundPre;
Procedure SetEnvironment(e:Environment);
Procedure GetEnvironment(Var e:Environment);
Procedure ProcEntry(Var e:Environment);
Procedure ProcExit(e:Environment);
Function GetHaltVector:LongInt;
Procedure SetHaltVector(v:LongInt);

 {Routine de comparaison }
Function Relation(x,y:Extended):Relop;

IMPLEMENTATION

 {Priv‚}
Function Log(x:Real):Real;
Var
 negatif:Boolean;
 fois,i:Integer;
 ajout,savx,xp,quotient,dl:Real;
Begin
 negatif := False;
 fois := 1;
 ajout := 0;
 If x <= 0.0 Then Begin
  Log:=0;
  Exit;
 End;
 If x < 1.0 Then Begin
  negatif := True;
  x := 1.0 / x;
 End;
 While x >= 10.0 do Begin
  x := x / 10.0;
  ajout := ajout + 2.302585092994046;
 End;
 While x >= 1.1 do Begin
  x := Sqrt(x);
  fois := fois * 2;
 End;
 x := x - 1;
 savx := x;
 i := 2;
 xp := x * x;
 quotient := (xp / i);
 dl := x - quotient;
 While 1.0E-15 < quotient do Begin
  i := i + 1;
  xp := xp * x;
  dl := dl + (xp / i);
  i := i + 1;
  xp := xp * x;
  quotient := (xp / i);
  dl := dl - quotient;
 End;
 dl := dl * fois;
 dl := dl + ajout;
 If(negatif)Then dl := - dl;
 Log:=dl;
End;

Function Power(base,p:Real):Real;Begin
 Power:=Exp(P*Log(Base))
End;

 {Public}
Function Num2Integer(X:extended):Integer;Begin
 Num2Integer:=Trunc(X);
End;

Function Num2Longint(X:extended):LongInt;Begin
 Num2LongInt:=Trunc(X);
End;

Function Num2Real(X:Extended):Real;Begin
 Num2Real:=X;
ENd;

Function Num2Double(X:Extended):Double;Begin
 Num2Double:=Extended(X);
End;

Function Num2Extended(X:Extended):Extended;Begin
 Num2Extended:=X;
End;

Function Num2Comp(X:Extended):Comp;Begin
 Num2Comp:=Trunc(X);
ENd;

Procedure Num2Dec(f:DecForm;x:extended;Var d:Decimal);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function Dec2Num(d:Decimal):Extended;Begin
 WriteLn('NON IMPLEMENTEE');
 Dec2Num:=0.0;
End;

Procedure Num2Str(f:DecForm;x:Extended;Var s:DecStr);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function Str2Num(s:DecStr):Extended;Begin
 WriteLn('NON IMPLEMENTEE');
 Str2Num:=0.0;
End;

Procedure Str2Dec(s:DecStr;Var Index:Integer;Var d:Decimal;Var ValidPrefix:Boolean);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Procedure CStr2Dec(s:CStrPtr;Var Index:Integer;Var d:Decimal;Var ValidPrefix:Boolean);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Procedure Dec2Str(f:DecForm;d:Decimal;Var s:DecStr);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function Remainder(x,y:Extended;Var Quo:Integer):Extended;Begin
 Remainder:=Trunc(x) div Trunc(y);
 Quo:=Trunc(x) mod Trunc(y);
End;

Function Rint(x:Extended):Extended;Begin
 Rint:=Round(x);
End;

Function Scalb(n:Integer;x:Extended):Extended;Begin
 Scalb:=x*Power(2,n);
End;

Function Logb(x:Extended):Extended;Begin
 WriteLn('NON IMPLEMENTEE');
 Logb:=0.0;
End;

Function CopySign(x,y:Extended):Extended;Begin
 If y<0 Then CopySign:=-Abs(x)
        Else CopySign:=Abs(x);
End;

Function NextReal(x,y:Real):Real;Begin
 WriteLn('NON IMPLEMENTEE');
 NextReal:=0.0;
End;

Function NextDouble(x,y:Double):Double;Begin
 WriteLn('NON IMPLEMENTEE');
 NextDouble:=0.0;
End;

Function NextExtended(x,y:Extended):Extended;Begin
 WriteLn('NON IMPLEMENTEE');
 NextExtended:=0.0;
End;

Function Log2(x:Extended):Extended;Begin
 Log2:=Log(x-2);
End;

Function Ln1(x:Extended):Extended;Begin
 Ln1:=Ln(1+x);
End;

Function Exp2(x:Extended):Extended;Begin
 Exp2:=Power(2,x);
End;

Function Exp1(x:Extended):Extended;Begin
 Exp1:=Exp(x)-1;
End;

Function XpwrI(x:Extended;i:Integer):Extended;Begin
 XpwrI:=Exp(x*Log(i));
End;

Function XpwrY(x,y:Extended):Extended;Begin
 XpwrY:=Exp(x*Log(y));
End;

Function Compound(r,n:Extended):Extended;Begin
 Compound:=Power(1+r,n)
End;

Function Annuity(r,n:Extended):Extended;Begin
 Annuity:=(1-Power(1+r,-n))/r;
End;

Function Tan(x:Extended):Extended;Begin
 Tan:=Sin(X)/Cos(X);
End;

Function RandomX(Var x:Extended):Extended;Begin
 X:=Random;
 RandomX:=X;
End;

Function ClassReal(x:Real):NumClass;Begin
 If x=0 Then ClassReal:=ZeroNum
        Else ClassReal:=NormalNum;
End;

Function ClassDouble(x:Double):NumClass;Begin
 If x=0 Then ClassDouble:=ZeroNum
        Else ClassDouble:=NormalNum;
End;

Function ClassComp(x:Comp):NumClass;Begin
 If x=0 Then ClassComp:=ZeroNum
        Else ClassComp:=NormalNum;
End;

Function ClassExtended(x:Extended):NumClass;Begin
 If x=0 Then ClassExtended:=ZeroNum
        Else ClassExtended:=NormalNum;
End;

Function SignNum(x:Extended):Integer;Begin
 If x<0 Then SignNum:=-1 Else
 If x>0 Then SignNum:=1
        Else SignNum:=0;
End;

Function NAN(i:Integer):Extended;Begin
 WriteLn('NON IMPLEMENTEE');
 NAN:=0.0;
End;

Procedure SetException(e:Exception;b:Boolean);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function TestException(e:Exception):Boolean;Begin
 WriteLn('NON IMPLEMENTEE');
 TestException:=False;
End;

Procedure SetHalt(e:Exception;b:Boolean);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function TestHalt(e:Exception):Boolean;Begin
 WriteLn('NON IMPLEMENTEE');
 TestHalt:=False;
End;

Procedure SetRound(r:RoundDir);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function GetRound:RoundDir;Begin
 WriteLn('NON IMPLEMENTEE');
 GetRound:=TowardZero;
End;

Procedure SetPrecision(p:RoundPre);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function GetPrecision:RoundPre;Begin
 WriteLn('NON IMPLEMENTEE');
 GetPrecision:=RealPrecision;
End;

Procedure SetEnvironment(e:Environment);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Procedure GetEnvironment(Var e:Environment);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Procedure ProcEntry(Var e:Environment);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Procedure ProcExit(e:Environment);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function GetHaltVector:LongInt;Begin
 WriteLn('NON IMPLEMENTEE');
 GetHaltVector:=0;
End;

Procedure SetHaltVector(v:LongInt);Begin
 WriteLn('NON IMPLEMENTEE');
End;

Function Relation(x,y:Extended):Relop;Begin
 If x>y Then Relation:=GreaterThan Else
 If x<y Then Relation:=LessThan
        Else Relation:=EqualTo;
End;

END.