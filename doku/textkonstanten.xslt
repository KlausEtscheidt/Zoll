<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>

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
  <!-- Variable fuer private:-->
  <xsl:variable name="private"><xsl:text>
        private: </xsl:text></xsl:variable>
  <!-- Variable fuer void-->
  <xsl:variable name="void"><xsl:text>
            void </xsl:text></xsl:variable>
  <!-- Variable fuer Einruecken Level 3-->
  <xsl:variable name="Level3"><xsl:text>
            </xsl:text></xsl:variable>

  
  
</xsl:stylesheet>
