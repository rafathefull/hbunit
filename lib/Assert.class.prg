//-- copyright
// hbunit is a unit-testing framework for the Harbour language.
//
// Copyright (C) 2014 Enderson maia <endersonmaia _at_ gmail _dot_ com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// See COPYRIGHT for more details.
//++

#include "hbunit.ch"

CLASS TAssert
  METHOD fail( cMsg )
  METHOD assertEquals( xExp, xAct, cMsg )
  METHOD assertNotEquals( xExp, xAct, cMsg )
  METHOD assertTrue( xAct, cMsg )
  METHOD assertFalse( xAct, cMsg )
  METHOD assertNil( xAct, cMsg )
  METHOD assertNotNil( xAct, cMsg )
  METHOD assert( xExp, xAct, cMsg, lInvert )

PROTECTED:
  METHOD isEqual( xExp, xAct )

ENDCLASS

METHOD fail( cMsg ) CLASS TAssert
  RETURN ( ::assert( .f.,, "Failure: " + cMsg ) )

METHOD assertEquals( xExp, xAct, cMsg ) CLASS TAssert
  LOCAL cErrMsg := ""

  cErrMsg += "Exp: " + ToStr( xExp, .t. )
  cErrMsg += ", Act: " + ToStr( xAct, .t. )
  cErrMsg += "( " + cMsg + " )"

  RETURN ( ::assert( xExp, xAct, cErrMsg ) )

METHOD assertNotEquals( xExp, xAct, cMsg ) CLASS TAssert
  LOCAL cErrMsg := ""

  cErrMsg += "Exp: not " + ToStr( xExp, .t. )
  cErrMsg += ", Act: " + ToStr( xAct )
  cErrMsg += "( " + cMsg + " )"

  RETURN ( ::assert( xExp, xAct, cErrMsg, .t. ) )

METHOD assertTrue( xAct, cMsg ) CLASS TAssert
  LOCAL cErrMsg := ""

  cErrMsg += "Exp: .t., Act: "
  cErrMsg += ToStr( xAct, .t. )
  cErrMsg += "( " + cMsg + " )"

  RETURN ( ::assert( .t., xAct , cErrMsg ) )

METHOD assertFalse( xAct, cMsg ) CLASS TAssert
  LOCAL cErrMsg := ""

  cErrMsg += "Exp: .f., Act: "
  cErrMsg += ToStr( xAct, .t. )
  cErrMsg += "( " + cMsg + " )"

  RETURN ( ::assert( .f., xAct , cErrMsg ) )

METHOD assertNil( xAct, cMsg ) CLASS TAssert
  LOCAL cErrMsg := ""

  cErrMsg += "Exp: nil, Act: "
  cErrMsg += ToStr( xAct, .t. )
  cErrMsg += "( " + cMsg + " )"

  RETURN ( ::assert( nil, xAct , cErrMsg ) )

METHOD assertNotNil( xAct, cMsg ) CLASS TAssert
  LOCAL cErrMsg := ""

  cErrMsg += "Exp: not nil, Act: "
  cErrMsg += ToStr( xAct, .t. )
  cErrMsg += "( " + cMsg + " )"

  RETURN ( ::assert( nil, xAct , cErrMsg, .t. ) )

METHOD assert( xExp, xAct, cMsg, lInvert ) CLASS TAssert
  LOCAL oError

  cMsg := ProcName(2) + ":" + LTRIM(STR(ProcLine(2))) + " => " + cMsg

  IF( lInvert == nil, lInvert := .f., )

  TRY
    ::oResult:IncrementAssertCount()

    IF (( lInvert .and. ::isEqual( xExp, xAct )) .or.;
        ( !( lInvert ) .and. ( !( ::isEqual( xExp, xAct  )))))
      ::oResult:AddFailure( ErrorNew( "EAssertFailure",,,, cMsg ) )
    ENDIF

  CATCH oError
    ::oResult:AddError( oError )
  END
  
  RETURN ( nil )

METHOD isEqual( xExp, xAct ) CLASS TAssert
  LOCAL lResult := .F.
  
  DO CASE
    CASE ValType( xExp ) != ValType( xAct )
    CASE ( !( xExp == xAct ))
    OTHERWISE
      lResult := .T.
  ENDCASE
RETURN ( lResult )

// #TODO - see where to put these util methods

FUNCTION toStr (xVal, lUseQuote )
  local cStr, i
  
  if( lUseQuote == nil, lUseQuote := .f., )
  
  DO CASE
  CASE ( ValType( xVal ) == "C" )
      cStr := xVal
  CASE ( ValType( xVal ) == "M" )
      cStr := xVal
  CASE ( ValType( xVal ) == "L" )
   cStr := if( xVal, ".t.", ".f." )
  CASE ( ValType( xVal ) ==  "D" )
   cStr := DToC( xVal )
  CASE ( ValType( xVal ) == "N" )
   cStr := LTrim( Str( xVal ) )
  CASE ( ValType( xVal ) == "A" )
   cStr := arrToStr( xVal )
  CASE ( ValType( xVal ) == "O" )
   cStr := "obj"
  CASE ( ValType( xVal ) == "B" )
   cStr := "blk"
  OTHERWISE
   cStr := "nil"
  END
  
  if ( lUseQuote .and. ValType( xVal ) == "C" )
    cStr := "'" + cStr+ "'"
  endif

  RETURN ( cStr )

FUNCTION arrToStr( aArr )
  LOCAL cStr := "", nArrLen := 0, i

  nArrLen = LEN( aArr )

  cStr += " ARRAY => { "
  FOR i := 1 TO nArrLen
    cStr += toStr( aArr[i] )
    IIF( i < nArrLen , cStr += "," , )
  NEXT
  cStr += " }"

  RETURN ( cStr )