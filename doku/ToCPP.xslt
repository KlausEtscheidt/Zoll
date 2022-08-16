<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>

<xsl:include href="textkonstanten.xslt"/>
  <!--
    Besonderheiten z.T aus https://www.data2type.de/xml-xslt-xslfo/xslt/xslt-kochbuch/von-xml-zu-text/umgang-mit-whitespace 
    <xsl:text/> verhindert zusaetzliche leerzeile
    normalize-space(.) trimmt
    leerzeichen:  &#160;
    <xsl:message terminate="no">Hallo</xsl:message>

    -->

  <xsl:output method="text" indent="no"/>

  <!-- Alle Elemente trimmen -->
  <xsl:strip-space elements="*"/>
  
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
    <xsl:apply-templates select="class"/>

  </xsl:template>
  <!-- Template fuer Klassen
  #######################################################################
  -->
  <xsl:template match="class">
    <!-- Leerzeile und dann Beschreibung -->
    <xsl:value-of select="$umbruch"/>
    <xsl:apply-templates select="devnotes"/>
    <!-- Klassen Deklaration erzeugen-->
      <xsl:value-of select="$class"/><xsl:value-of select="@name"/>:<xsl:value-of select="$Leer"/>public<xsl:value-of select="$Leer"/><xsl:value-of select="ancestor/@name"/>{<xsl:text/>
      <xsl:value-of select="$umbruch"/>

      <xsl:if test="count(members/*[@visibility != 'public']) > 0">
        <xsl:value-of select="$private"/>
      </xsl:if> 
      <xsl:apply-templates select="members/*[@visibility != 'public']"/>
      <xsl:value-of select="$umbruch"/>

      <xsl:if test="count(members/*[@visibility = 'public']) > 0">
        <xsl:value-of select="$public"/>
      </xsl:if> 
      <xsl:apply-templates select="members/*[@visibility = 'public']"/>
      <xsl:value-of select="$umbruch"/>
    };
  </xsl:template>


    <!-- Template Klassen-Member
  #######################################################################
  -->
  <xsl:template match="membersss">
    public:
    <xsl:value-of select="@visibility"/>
    public:
    <!--
    <xsl:apply-templates select="function"/>
    <xsl:apply-templates select="field"/>
    <xsl:apply-templates select="property"/>
    -->
  </xsl:template>

  <xsl:template match="procedure">
      <xsl:value-of select="$Level3"/>//procedure<xsl:text/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Funktionskopf erzeugen-->
      <xsl:value-of select="$void"/><xsl:value-of select="@name"/>(<xsl:text/>
      <xsl:apply-templates select="parameters"  mode="fkopf"/>);<xsl:text/>
      <xsl:value-of select="$umbruch"/>
  </xsl:template>

  <xsl:template match="function">
      <xsl:value-of select="$Level3"/>//function<xsl:text/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Funktionskopf erzeugen-->
      <xsl:value-of select="$Level3"/><xsl:value-of select="parameters/retval/@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>(<xsl:text/>
      <xsl:apply-templates select="parameters" mode="fkopf"/>);<xsl:text/>
      <xsl:value-of select="$umbruch"/>
  </xsl:template>

  <xsl:template match="field">
      <xsl:value-of select="$Level3"/>//field<xsl:text/>
      <xsl:apply-templates select="devnotes"/>
      <!-- Deklaration erzeugen-->
      <xsl:value-of select="$Level3"/><xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>;<xsl:text/>
      <xsl:value-of select="$umbruch"/>
  </xsl:template>

  <xsl:template match="property">
        <xsl:value-of select="$Level3"/>//property<xsl:text/>
        <xsl:apply-templates select="devnotes"/>
        <xsl:value-of select="$Level3"/><xsl:value-of select="@type"/><xsl:value-of select="$Leer"/><xsl:value-of select="@name"/>;<xsl:text/>
      <xsl:value-of select="$umbruch"/>
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
