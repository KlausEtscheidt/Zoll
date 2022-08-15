<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="text" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!--
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
    -->
  <xsl:template match="/">
    Unit: <xsl:value-of select="/namespace/@name"/>

    <xsl:apply-templates select="/namespace/devnotes"/>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="summary">
            <!--leerzeichen dazu &#160; bzw weg normalize-space()-->
            summary&#160;<xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template match="remarks">
            remarks&#160;<xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template match="devnotes">
        <!--<xsl:text/> verhindert zusaetzliche leerzeile
        https://www.data2type.de/xml-xslt-xslfo/xslt/xslt-kochbuch/von-xml-zu-text/umgang-mit-whitespace -->
        devnotes:<xsl:text/>
                <xsl:apply-templates select="summary"/>
                <xsl:apply-templates select="remarks"/>
  </xsl:template>

  <xsl:template match="/namespace">
    <xsl:for-each select="class">
      class
        <xsl:value-of select="@name"/>(<xsl:value-of select="ancestor/@name"/>)<xsl:text/>
        <xsl:apply-templates select="devnotes"/>
        <xsl:apply-templates select="members"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="members">
    <xsl:for-each select="procedure">
      procedure
        <xsl:value-of select="@name"/>
        <xsl:apply-templates select="devnotes"/>
        <xsl:apply-templates select="parameters"/>
    </xsl:for-each>
    <xsl:for-each select="function">
      function
        <xsl:value-of select="parameters/retval/@type"/> &#160; <xsl:value-of select="@name"/>
        <xsl:apply-templates select="devnotes"/>
        <xsl:apply-templates select="parameters"/>
    </xsl:for-each>
    <xsl:for-each select="field">
      field
        <xsl:value-of select="@type"/> &#160; <xsl:value-of select="@name"/>
        <xsl:apply-templates select="devnotes"/>
    </xsl:for-each>
    <xsl:for-each select="property">
      property
        <xsl:value-of select="@type"/> &#160; <xsl:value-of select="@name"/>
        <xsl:apply-templates select="devnotes"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="parameters">
    <xsl:for-each select="parameter">
        parameter  <xsl:value-of select="@type"/> &#160; <xsl:value-of select="@name"/>
        <xsl:apply-templates select="devnotes"/>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
