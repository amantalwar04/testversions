<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
  <xsl:output method="xml" version="1.0" indent="yes" standalone="yes" />
  <xsl:template match="/">
    <doxygen version="{doxygenindex/@version}">
      <!--create dummy compounddef node and its children to contain memberdefs according to original doxygen files-->
<xsl:comment>
 ***** GROUP COMPOUNDDEF *****
</xsl:comment>
      <xsl:apply-templates select="//compound[@kind=&quot;group&quot;]"/>
      <!-- find all structure compounddefs and make their copy with their member children-->
<xsl:comment>
 ***** STRUCT COMPOUNDDEFS *****
</xsl:comment>
      <xsl:apply-templates select="//compound[@kind=&quot;struct&quot;]"/>
<xsl:comment>
 ***** CLASS COMPOUNDDEF *****
</xsl:comment>
      <xsl:apply-templates select="//compound[@kind=&quot;class&quot;]"/>	  
    </doxygen>
  </xsl:template>


  <!-- This template selects only one (the first) from many possible member nodes
       with equal name childnode and creates a copy of it in resulting document. 
       Rationale: Member nodes (imagine decription of a C function) can occur in
       multiple copy in different files with same(probably nodes in group) or different ID
       (copy of desritpion is put into header file compound, source file and group).
       Original Doxygen template makes a copy of each of them into resulting file which
       causes two problems:
         - Invalid XML document when two or more copies with same ID are present.
         - An error when writing DITA output file with same name again due to presence 
           of two or more copies with same name.  
       -->
  <xsl:template match="member">
    <!--put refid of curent node to a variable-->
    <xsl:variable name="refid"><xsl:value-of select="@refid"/></xsl:variable>
    <!--put name of curent member to a variable-->
    <xsl:variable name="name"><xsl:value-of select="name"/></xsl:variable>
    <!--get position of this node in ordered row of nodes with same name -->
    <xsl:variable name="position"><xsl:number count="//member[name=$name]" level="any"/></xsl:variable>  
    <!--produce output only if current node is first from them-->
    <xsl:if test="$position=1">
      <!--find parent compound for this member and store its refid into a variable-->
      <xsl:variable name="compoundrefid" select="ancestor::compound/attribute::refid"/>
      <xsl:comment>Copy from file <xsl:value-of select="$compoundrefid"/>.xml</xsl:comment>
      <xsl:comment>name <xsl:value-of select="$name"/></xsl:comment>
      <xsl:comment>refid <xsl:value-of select="$refid"/>.xml</xsl:comment>      
      <!--open the parent compound file and copy a member selected by original ID from it into the resulting document-->
      <xsl:copy-of select="document(concat($compoundrefid,'.xml'))//*[@id=$refid]"/>      
    </xsl:if> 
  </xsl:template>

  <!-- This template copies all structure compounddefs with their memberdefs 
       - structure description needs compounddefs in resulting document because
       it groups its members (meberdef[@kind=variable]) together. Usage fo these meberdefs
       separately without compounddef has no sense.
  -->
  <xsl:template match="compound[@kind=&quot;struct&quot;]">
        <!--put compounddefs name into a variable-->
        <xsl:variable name="refid"><xsl:value-of select="@refid"/></xsl:variable>
        <!-- copy selected compounddef into resulting document --> 
        <xsl:comment>Copy from file <xsl:value-of select="$refid"/>.xml</xsl:comment>
        <xsl:copy-of select="document(concat($refid,'.xml'))//*[@id=$refid]"/>      
  </xsl:template>

   <xsl:template match="compound[@kind=&quot;group&quot;]">
        <!--put compounddefs name into a variable-->
        <xsl:variable name="refid"><xsl:value-of select="@refid"/></xsl:variable>
        <!-- copy selected compounddef into resulting document --> 
        <xsl:comment>Copy from file <xsl:value-of select="$refid"/>.xml</xsl:comment>
        <xsl:copy-of select="document(concat($refid,'.xml'))//*[@id=$refid]"/>      
  </xsl:template> 

   <xsl:template match="compound[@kind=&quot;class&quot;]">
        <!--put compounddefs name into a variable-->
        <xsl:variable name="refid"><xsl:value-of select="@refid"/></xsl:variable>
        <!-- copy selected compounddef into resulting document --> 
        <xsl:comment>Copy from file <xsl:value-of select="$refid"/>.xml</xsl:comment>
        <xsl:copy-of select="document(concat($refid,'.xml'))//*[@id=$refid]"/>      
  </xsl:template>   
</xsl:stylesheet>
