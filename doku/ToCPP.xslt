<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>

  <!--
    Besonderheiten z.T aus https://www.data2type.de/xml-xslt-xslfo/xslt/xslt-kochbuch/von-xml-zu-text/umgang-mit-whitespace 
    <xsl:text/> verhindert zusaetzliche leerzeile
    normalize-space(.) trimmt
    leerzeichen:  &#160;
    -->

  <xsl:output method="text" indent="no"/>

  <!-- Alle Elemente trimmen -->
  <xsl:strip-space elements="*"/>
  <!-- Variable fuer Zeilenumbruch-->
  <xsl:variable name="umbruch"><xsl:text>
  </xsl:text></xsl:variable>
  <!-- Variable fuer Kommentar-Start-->
  <xsl:variable name="KStart"><xsl:text>  /** </xsl:text></xsl:variable>
  <!-- Variable fuer Kommentar-Ende-->
  <xsl:variable name="KStop"><xsl:text>
   */</xsl:text></xsl:variable>
  <!-- Variable fuer Kommentar-->
  <xsl:variable name="K"><xsl:text>
   * </xsl:text></xsl:variable>
  <!-- Variable fuer Blank-->
  <xsl:variable name="Leer"><xsl:text> </xsl:text></xsl:variable>

  <!-- Template fuer root -->
  <xsl:template match="/">
      <xsl:apply-templates select="/namespace"/>
  </xsl:template>

  <!-- Template fuer namespace (toplevel)
  #######################################################################
  -->
  <xsl:template match="/namespace">
    <!-- Doku fuer Unit ausgeben (muss am Dateianfang stehen) -->
    <xsl:value-of select="$KStart"/>
    <xsl:value-of select="$K"/>\file <xsl:value-of select="./@name"/><xsl:text/>
    <xsl:apply-templates select="devnotes/summary"/>
    <xsl:apply-templates select="devnotes/remarks"/>
    <xsl:value-of select="$KStop"/>
     
    <!-- Doku fuer Klassen  -->
    <xsl:for-each select="class">
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Klassen Deklaration erzeugen-->
      class<xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>:<xsl:value-of select="$Leer"/>public<xsl:value-of select="$Leer"/><xsl:value-of select="ancestor/@name"/>{<xsl:text/>
        <xsl:apply-templates select="members"/>
        <xsl:value-of select="$umbruch"/>
      };
    </xsl:for-each>
    
  </xsl:template>

  <!-- Template fuer devnotes (wird von fast allen Templates auf gerufen)
  #######################################################################
  -->
  <xsl:template match="devnotes">
    <xsl:value-of select="$KStart"/>
    <xsl:apply-templates select="summary"/>
    <xsl:apply-templates select="remarks"/>
    <xsl:value-of select="$KStop"/>
  </xsl:template>

  <xsl:template match="summary">
    <xsl:value-of select="$K"/><xsl:value-of select="normalize-space(.)"/>
    <xsl:value-of select="$K"/>
  </xsl:template>

  <xsl:template match="remarks">
    <xsl:value-of select="$K"/><xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- Template Klassen-Member
  #######################################################################
  -->
  <xsl:template match="members">
    public:
    <xsl:for-each select="procedure">
      //procedure
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Funktionskopf erzeugen-->
      void<xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>(<xsl:text/>
      <xsl:apply-templates select="parameters"  mode="fkopf"/>);<xsl:text/>
    </xsl:for-each>

    <xsl:for-each select="function">
      //function
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Funktionskopf erzeugen-->
      <xsl:value-of select="$umbruch"/>
      <xsl:value-of select="parameters/retval/@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>(<xsl:text/>
      <xsl:apply-templates select="parameters" mode="fkopf"/>);<xsl:text/>
    </xsl:for-each>

    <xsl:for-each select="field">
      //field
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Deklaration erzeugen-->
      <xsl:value-of select="$umbruch"/>
      <xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>;<xsl:text/>
    </xsl:for-each>

    <xsl:for-each select="property">
      //property
        <xsl:apply-templates select="devnotes"/>
        <xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>;<xsl:text/>
    </xsl:for-each>

  </xsl:template>

  <!-- Template Parameter
  #######################################################################
  -->

  <!-- Template Parameter fuer Funktionskopf -->
  <xsl:template match="parameters"  mode="fkopf">
    <xsl:for-each select="parameter">
       <xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>
        <xsl:if test="position() != last()">
          <xsl:text>; </xsl:text>
        </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template Parameter fuer Parameterdoku -->
  <xsl:template match="parameters" >
    <xsl:for-each select="parameter">
        //parameter  <xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>
        <xsl:apply-templates select="devnotes"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
