<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
<xsl:include href="textkonstanten.xsl"/>
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
  <xsl:variable name="KStart"><xsl:text> 
  /** </xsl:text></xsl:variable>
  <!-- Variable fuer Kommentar-Ende-->
  <xsl:variable name="KStop"><xsl:text>
   */</xsl:text></xsl:variable>
  <!-- Variable fuer Kommentar-->
  <xsl:variable name="K"><xsl:text>
   * </xsl:text></xsl:variable>
  <!-- Variable fuer Blank-->
  <xsl:variable name="Leer"><xsl:text> </xsl:text></xsl:variable>
  <!-- Variable fuer class-->
  <xsl:variable name="class"><xsl:text>
      class </xsl:text></xsl:variable>
  <!-- Variable fuer public:-->
  <xsl:variable name="public"><xsl:text>
         public: </xsl:text></xsl:variable>
  <!-- Variable fuer public:-->
  <xsl:variable name="private"><xsl:text>
         private: </xsl:text></xsl:variable>
  
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
    <xsl:value-of select="$K"/>\namespace <xsl:value-of select="./@name"/><xsl:text/>
    <xsl:apply-templates select="devnotes/summary"/>
    <xsl:apply-templates select="devnotes/remarks"/>
    <xsl:value-of select="$KStop"/>
    <xsl:value-of select="$umbruch"/>
     
    <!-- Doku fuer Klassen  -->
    <xsl:for-each select="class">
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Klassen Deklaration erzeugen-->
        <xsl:value-of select="$class"/><xsl:value-of select="@name"/>:<xsl:value-of select="$Leer"/>public<xsl:value-of select="$Leer"/><xsl:value-of select="ancestor/@name"/>{<xsl:text/>
        <xsl:value-of select="$umbruch"/>
        <xsl:value-of select="$private"/>
        <xsl:apply-templates select="members/*[@visibility != 'public']"/>
        <xsl:value-of select="$umbruch"/>
        <xsl:value-of select="$public"/>
        <xsl:apply-templates select="members/*[@visibility = 'public']"/>
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
    <xsl:apply-templates select="param"/>
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
    <xsl:value-of select="./procedure[1]"/>
    public:
    <xsl:apply-templates select="procedure"/>
    <xsl:apply-templates select="function"/>
    <xsl:apply-templates select="field"/>
    <xsl:apply-templates select="property"/>
    -----------------------------------------------------------
  </xsl:template>

  <xsl:template match="procedure">
      //procedure
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Funktionskopf erzeugen-->
      void<xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>(<xsl:text/>
      <xsl:apply-templates select="parameters"  mode="fkopf"/>);<xsl:text/>
  </xsl:template>

  <xsl:template match="function">
      //function
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Funktionskopf erzeugen-->
      <xsl:value-of select="$umbruch"/>
      <xsl:value-of select="parameters/retval/@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>(<xsl:text/>
      <xsl:apply-templates select="parameters" mode="fkopf"/>);<xsl:text/>
  </xsl:template>

  <xsl:template match="field">
      //field
      <xsl:value-of select="$umbruch"/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Deklaration erzeugen-->
      <xsl:value-of select="$umbruch"/>
      <xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>;<xsl:text/>
  </xsl:template>

  <xsl:template match="property">
      //property
        <xsl:apply-templates select="devnotes"/>
        <xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>;<xsl:text/>
  </xsl:template>

  <!-- Template Parameter
  #######################################################################
  -->

  <!-- Template Parameter fuer Funktionskopf -->
  <xsl:template match="parameters"  mode="fkopf">
    <xsl:for-each select="parameter">
       <xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template Parameter fuer Parameterdoku -->
  <xsl:template match="param" >
    <xsl:value-of select="$K"/>@param<xsl:value-of select="$Leer"/><xsl:value-of select="@name"/><xsl:value-of select="$Leer"/><xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
