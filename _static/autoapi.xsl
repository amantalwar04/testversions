<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
  <xsl:output method="xml" indent="no"/>
  <xsl:strip-space
    elements="doxygen compounddef bold para briefdescription detaileddescription simplesect 
                             memberdef programlisting codeline highlight type"/>
  <!-- overide built-in template for text nodes copy - nothing put into output -->
  <xsl:template match="*" priority="-10"/>
  <xsl:template match="text() | @*" priority="-5"/>
  <xsl:template match="text() | @*" mode="macro-idx"/>
  <xsl:template match="text() | @*" mode="func-idx"/>
  <!-- DITA Map -->
  <xsl:template match="/doxygen">
    <xsl:variable name="APIVersion">
      <xsl:text>Version 0.0.1</xsl:text>
    </xsl:variable>

    <xsl:variable name="ditamap">
      <xsl:value-of select="resolve-uri('xilpm_AutoAPI.ditamap')"/>
    </xsl:variable>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd"
      indent="yes" method="xml" href="{$ditamap}">
      <!-- DITA map can be indented since it contains no <codeblock> -->
      <map xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" xml:lang="en-us">
        <title>XilPM API Reference Guide </title>


        <!-- Content begins here -->

        <xsl:apply-templates select="//compounddef[@kind = &quot;group&quot;]" mode="grpstructure"> </xsl:apply-templates>
        <xsl:apply-templates select="//compounddef[@kind = &quot;class&quot;]" mode="namespace"> </xsl:apply-templates>
        <topicref href="structure_index.xml" navtitle="Data Structures">
          <xsl:apply-templates select="//compounddef[@kind = &quot;struct&quot;]" mode="structure"
          > </xsl:apply-templates>
        </topicref>

      </map>
    </xsl:result-document>


    <!-- DITA topics generation -->
    
    <xsl:apply-templates select="//memberdef[@kind = &quot;function&quot;]"/>
    <xsl:apply-templates select="//memberdef[@kind = &quot;define&quot;]"/>
    <xsl:apply-templates select="//memberdef[@kind = &quot;typedef&quot;]"/>
    <xsl:apply-templates select="//memberdef[@kind = &quot;enum&quot;]"/>
    <xsl:apply-templates select="//memberdef[@kind = &quot;variable&quot;]"/>
    <xsl:apply-templates select="//compounddef[@kind = &quot;struct&quot;]"/>
    <xsl:apply-templates select="//compounddef[@kind = &quot;group&quot;]"/>
    <xsl:apply-templates select="//compounddef[@kind = &quot;class&quot;]"/>

    <xsl:apply-templates select="//compounddef[@kind = &quot;group&quot;]" mode="grpmapstructure"/>


    <!-- DITA topic with Structure index -->
    <xsl:variable name="StructureMemberdefs" select="//compounddef[@kind = &quot;struct&quot;]"/>
    <xsl:variable name="filename" select="resolve-uri(concat('', 'structure_index', '.xml'))"/>
    <xsl:result-document doctype-public="-//XILINX//DTD DITA Composite//EN"
      doctype-system="XilinxDitabase.dtd" indent="yes" method="xml" href="{$filename}">
      <topic>
        <xsl:attribute name="id">
          <xsl:text>strucuture_index</xsl:text>
        </xsl:attribute>
        <title>
          <xsl:text>Data Structure Index</xsl:text>
        </title>
        <body>
          <p>The following is a list of data structures:</p>
          <ul>
            <xsl:apply-templates select="$StructureMemberdefs" mode="struct_idx">
              <xsl:sort select="compoundname" data-type="text" order="ascending"/>
            </xsl:apply-templates>
          </ul>
        </body>
      </topic>
    </xsl:result-document>

    <!-- DITA topic with Class index -->
    <xsl:variable name="ClassMemberdefs" select="//compounddef[@kind = &quot;class&quot;]"/>
    <xsl:variable name="fname" select="resolve-uri(concat('', 'class_index', '.xml'))"/>
    <xsl:result-document doctype-public="-//XILINX//DTD DITA Composite//EN"
      doctype-system="XilinxDitabase.dtd" indent="yes" method="xml" href="{$fname}">
      <topic>
        <xsl:attribute name="id">
          <xsl:text>class_index</xsl:text>
        </xsl:attribute>
        <title>
          <xsl:text>Class Index</xsl:text>
        </title>
        <body>
          <p>The following is a list of name spaces:</p>
          <ul>
            <xsl:apply-templates select="$ClassMemberdefs" mode="struct_idx">
              <xsl:sort select="compoundname" data-type="text" order="ascending"/>
            </xsl:apply-templates>
          </ul>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>
  
  <!-- Templates for structure creation  -->
  <xsl:template match="compounddef" mode="structure">
    <topicref>
      <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
    </topicref>
  </xsl:template>


  <!--      Template for Group ditamap -->
  <xsl:template match="compounddef" mode="grpmapstructure">
    <xsl:variable name="GroupId" select="@id"/>
    <xsl:variable name="GroupMemberdefs" select="//memberdef[@kind = &quot;function&quot;]"/>
    <xsl:variable name="group_name">
      <xsl:value-of select="compoundname"/>
    </xsl:variable>
    <xsl:variable name="group_title">
      <xsl:value-of select="title"/>
    </xsl:variable>
    <xsl:variable name="filename" select="resolve-uri(concat('', $GroupId, '.ditamap'))"/>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd"
      indent="yes" method="xml" href="{$filename}">
      <!-- DITA map can be indented since it contains no <codeblock> -->
      <map xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" xml:lang="en-us">
        <title>
          <xsl:value-of select="$group_title"/>
        </title>


        <!-- Content begins here -->
        <topicref>
          <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
		    <xsl:if test="sectiondef/memberdef[@kind = &quot;function&quot;]">
            <topicref navtitle="Functions">
              <xsl:for-each select="sectiondef/memberdef[@kind = &quot;function&quot;]">
                <topicref>
                  <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
                </topicref>
              </xsl:for-each>
            </topicref>
          </xsl:if>

          <xsl:if test="sectiondef/memberdef[@kind = &quot;enum&quot;]">
            <topicref navtitle="Enumerations">
              <xsl:for-each select="sectiondef/memberdef[@kind = &quot;enum&quot;]">
                <topicref>
                  <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
                </topicref>
              </xsl:for-each>
            </topicref>
          </xsl:if>
          <xsl:for-each select="innergroup">
            <mapref>
              <xsl:attribute name="format">
                <xsl:text>ditamap</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="@refid"/>.ditamap</xsl:attribute>
            </mapref>
          </xsl:for-each>


<!--
          <xsl:if test="sectiondef/memberdef[@kind = &quot;define&quot;]">
            <topicref navtitle="Definitions">
              <xsl:for-each select="sectiondef/memberdef[@kind = &quot;define&quot;]">
                <topicref>
                  <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
                </topicref>
              </xsl:for-each>
            </topicref>
          </xsl:if> -->
        </topicref>
      </map>
    </xsl:result-document>



  </xsl:template>

  <!-- Templates for group creation  -->
  <xsl:template match="compounddef" mode="grpstructure">
    <topicref>
      <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>

      <xsl:if test="sectiondef/memberdef[@kind = &quot;function&quot;]">
        <topicref navtitle="Functions">
          <xsl:for-each select="sectiondef/memberdef[@kind = &quot;function&quot;]">
            <topicref>
              <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
            </topicref>
          </xsl:for-each>
        </topicref>
      </xsl:if>

      <xsl:if test="sectiondef/memberdef[@kind = &quot;enum&quot;]">
        <topicref navtitle="Enumerations">
          <xsl:for-each select="sectiondef/memberdef[@kind = &quot;enum&quot;]">
            <topicref>
              <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
            </topicref>
          </xsl:for-each>
        </topicref>
      </xsl:if>


<!--       <xsl:if test="sectiondef/memberdef[@kind = &quot;define&quot;]">
        <topicref navtitle="Definitions">
          <xsl:for-each select="sectiondef/memberdef[@kind = &quot;define&quot;]">
            <topicref>
              <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
            </topicref>
          </xsl:for-each>
        </topicref>
      </xsl:if> -->
    </topicref>
  </xsl:template>

  <!-- Template for class creation -->
  <xsl:template match="compounddef" mode="namespace">
    <topicref>
      <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
      <xsl:if test="sectiondef/memberdef[@kind = &quot;function&quot;]">
        <topicref navtitle="Functions">
          <xsl:for-each select="sectiondef/memberdef[@kind = &quot;function&quot;]">
            <topicref>
              <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
            </topicref>
          </xsl:for-each>
        </topicref>
      </xsl:if>

      <xsl:if test="sectiondef/memberdef[@kind = &quot;enum&quot;]">
        <topicref navtitle="Enumerations">
          <xsl:for-each select="sectiondef/memberdef[@kind = &quot;enum&quot;]">
            <topicref>
              <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
            </topicref>
          </xsl:for-each>
        </topicref>
      </xsl:if>


      <xsl:if test="sectiondef/memberdef[@kind = &quot;define&quot;]">
        <topicref navtitle="Definitions">
          <xsl:for-each select="sectiondef/memberdef[@kind = &quot;define&quot;]">
            <topicref>
              <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
            </topicref>
          </xsl:for-each>
        </topicref>
      </xsl:if>
    </topicref>
  </xsl:template>


  <!-- Template for function documentation-->
  <xsl:template match="memberdef[@kind = &quot;function&quot;]">
    <xsl:variable name="func_id">
      <xsl:value-of select="@id"/>
    </xsl:variable>



    <xsl:variable name="func_name">
      <xsl:value-of select="name"/>
    </xsl:variable>
    <xsl:variable name="filename" select="resolve-uri(concat('', $func_id, '.xml'))"/>
    <xsl:result-document doctype-public="-//XILINX//DTD DITA Composite//EN"
      doctype-system="XilinxDitabase.dtd" indent="yes" method="xml" href="{$filename}">
      <reference xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" xml:lang="en-us">
        <xsl:attribute name="id">
          <xsl:value-of select="$func_id"/>
        </xsl:attribute>
        <title>
          <xsl:value-of select="$func_name"/>
        </title>

        <refbody>
          <section>
            <xsl:if test="boolean(briefdescription/*)">
              <p>
                <xsl:apply-templates select="briefdescription"/>
              </p>
            </xsl:if>
            <xsl:apply-templates select="detaileddescription"/>

            <xsl:if test="not(boolean(briefdescription/*)) and not(boolean(detaileddescription/*))">
              <xsl:comment>This member contains no brief or detailed description.</xsl:comment>
              <xsl:message terminate="no"> WARNING: No description added to <xsl:value-of
                  select="name"/> function. </xsl:message>
            </xsl:if>
            <xsl:call-template name="process_remarks"/>
          </section>
          <section>
            <title>Prototype</title>
            <codeblock>
              <xsl:apply-templates select="type"/>
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="name"/>
              <xsl:apply-templates select="argsstring"/>
              <xsl:text>;</xsl:text>
            </codeblock>
          </section>
          <xsl:if test="boolean(detaileddescription//parameterlist/parameteritem)">
            <section>
              <title>Parameters</title>
              <p>
                <xsl:text>The following table lists the </xsl:text>
                <codeph>
                  <xsl:apply-templates select="name"/>
                </codeph>
                <xsl:text> function arguments.</xsl:text>
              </p>
              <table colsep="1" rowsep="1">
                <title>
                  <xsl:apply-templates select="name"/>
                  <xsl:text> Arguments</xsl:text>
                </title>
                <tgroup cols="3">
                  <colspec colnum="1" colname="c0" colwidth="2*"/>
                  <colspec colnum="2" colname="c1" colwidth="2*"/>
                  <colspec colnum="3" colname="c2" colwidth="5*"/>
                  <thead>
                    <row>
                      <entry>Type</entry>
                      <entry>Name</entry>
                      <entry>Description</entry>
                    </row>
                  </thead>
                  <tbody>
                    <xsl:apply-templates
                      select="detaileddescription/para/parameterlist/parameteritem"/>
                  </tbody>
                </tgroup>
              </table>
            </section>
          </xsl:if>

          <xsl:if test="boolean(detaileddescription/para/simplesect)">

            <section>
              <title>Returns</title>
              <xsl:for-each select="descendant::simplesect[@kind = &quot;return&quot;]/para">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </section>
          </xsl:if>
        </refbody>
      </reference>
    </xsl:result-document>
  </xsl:template>

  <!-- Template for Typedefs -->
  <xsl:template match="memberdef[@kind = &quot;typedef&quot;]">
    <xsl:variable name="typedef_name">
      <xsl:value-of select="name"/>
    </xsl:variable>
    <xsl:variable name="typedef_id">
      <xsl:value-of select="@id"/>
    </xsl:variable>
    <xsl:variable name="filename" select="resolve-uri(concat('generated/', $typedef_id, '.xml'))"/>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Topic//EN"
      doctype-system="XilinxDitabase.dtd" indent="yes" method="xml" href="{$filename}">
      <topic xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/">
        <xsl:attribute name="id">
          <xsl:value-of select="$typedef_id"/>
        </xsl:attribute>
        <title>
          <xsl:text>Typedef </xsl:text>
          <xsl:value-of select="$typedef_name"/>
        </title>
        <xsl:if test="boolean(briefdescription/*)">
          <abstract>
            <xsl:apply-templates select="briefdescription"/>
          </abstract>
        </xsl:if>
        <body>
          <p>
            <b>
              <u>Type:</u>
            </b>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="type"/>
          </p>
          <xsl:apply-templates select="detaileddescription"/>
          <xsl:call-template name="process_remarks"/>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>

  <!-- Template for Defines 
  <xsl:template match="memberdef[@kind = &quot;define&quot;]">
    <xsl:variable name="define_id">
      <xsl:value-of select="@id"/>
    </xsl:variable>
    <xsl:variable name="define_name">
      <xsl:value-of select="name"/>
    </xsl:variable>
    <xsl:variable name="filename" select="resolve-uri(concat($define_id, '.xml'))"/>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Reference//EN"
      doctype-system="XilinxDitabase.dtd" indent="yes" method="xml" href="{$filename}">
      <reference xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/">
        <xsl:attribute name="id">
          <xsl:value-of select="$define_id"/>
        </xsl:attribute>
        <title>
          <xsl:text>Define </xsl:text>
          <xsl:value-of select="$define_name"/>
        </title>
        <xsl:if test="boolean(briefdescription/*)">
          <abstract>
            <xsl:apply-templates select="briefdescription"/>
          </abstract>
        </xsl:if>
        <refbody>
          <section>
            <title>
              <xsl:text>Definition</xsl:text>
            </title>
            <codeblock>
              <xsl:text>#define </xsl:text>
              <xsl:value-of select="name"/>
              <xsl:apply-templates select="initializer"/>
            </codeblock>
          </section>
          <section>
            <title>Description</title>

            <xsl:apply-templates select="briefdescription"/>
            <xsl:apply-templates select="detaileddescription"/>
            <xsl:if test="not(boolean(briefdescription/*)) and not(boolean(detaileddescription/*))">
              <xsl:comment>This member contains no brief or detailed description.</xsl:comment>
              <xsl:message terminate="no"> WARNING: No description added to the <xsl:value-of
                  select="name"/> definition. </xsl:message>
            </xsl:if>

          </section>
        </refbody>
      </reference>
    </xsl:result-document>
  </xsl:template>-->


  <!-- Template for Enumerations -->
  <xsl:template match="memberdef[@kind = &quot;enum&quot;]">
    <xsl:variable name="enum_name">
      <xsl:value-of select="name"/>
    </xsl:variable>
    <xsl:variable name="enum_id">
      <xsl:value-of select="@id"/>
    </xsl:variable>
    <xsl:variable name="filename" select="resolve-uri(concat($enum_id, '.xml'))"/>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Topic//EN"
      doctype-system="XilinxDitabase.dtd" indent="yes" method="xml" href="{$filename}">
      <topic xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/">
        <xsl:attribute name="id">
          <xsl:value-of select="$enum_id"/>
        </xsl:attribute>
        <title>
          <xsl:text>Enumeration </xsl:text>
          <xsl:value-of select="$enum_name"/>
        </title>
        <xsl:if test="boolean(briefdescription/*)">
          <abstract>
            <xsl:apply-templates select="briefdescription"/>
          </abstract>
        </xsl:if>
        <body>
          <xsl:apply-templates select="detaileddescription"/>
          <table colsep="1" rowsep="1">
            <title>
              <xsl:text>Enumeration </xsl:text>
              <xsl:value-of select="name"/>
              <xsl:text> Values</xsl:text>
            </title>
            <tgroup cols="2">
              <colspec colnum="1" colname="c0" colwidth="2*"/>
              <colspec colnum="2" colname="c1" colwidth="3*"/>
              <thead>
                <row>
                  <entry>
                    <xsl:text>Value</xsl:text>
                  </entry>
                  <entry>
                    <xsl:text>Description</xsl:text>
                  </entry>
                </row>
              </thead>
              <tbody>
                <xsl:for-each select="enumvalue">
                  <row>
                    <entry>
                      <xsl:apply-templates select="name"/>
                    </entry>
                    <entry>
                      <xsl:apply-templates select="briefdescription"/>
                      <xsl:apply-templates select="detaileddescription"/>
                      <xsl:if
                        test="not(boolean(briefdescription/*)) and not(boolean(detaileddescription/*))">
                        <xsl:comment>This member contains no brief or detailed description.</xsl:comment>
                        <xsl:message terminate="no"> WARNING: No description added to <xsl:value-of
                            select="name"/> enum value. </xsl:message>
                      </xsl:if>
                    </entry>
                  </row>
                </xsl:for-each>
                <!--><xsl:apply-templates select="enumvalue"/><-->
              </tbody>
            </tgroup>
          </table>
          <xsl:call-template name="process_remarks"/>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>

  <!-- Special template for Groups -->
  <xsl:template match="compounddef[@kind = &quot;group&quot;]">
    <xsl:variable name="GroupId" select="@id"/>
    <xsl:variable name="GroupMemberdefs" select="//memberdef[@kind = &quot;function&quot;]"/>
    <xsl:variable name="group_name">
      <xsl:value-of select="compoundname"/>
    </xsl:variable>
    <xsl:variable name="group_title">
      <xsl:value-of select="title"/>
    </xsl:variable>
    <xsl:variable name="filename" select="resolve-uri(concat('', $GroupId, '.xml'))"/>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Composite//EN"
      doctype-system="XilinxDitabase.dtd" indent="no" method="xml" href="{$filename}">

      <xsl:comment>topic <xsl:value-of select="$group_name"/></xsl:comment>
      <topic xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/">
        <xsl:attribute name="id">
          <xsl:value-of select="$GroupId"/>
        </xsl:attribute>
        <title>
          <xsl:value-of select="$group_title"/>
        </title>
        <body>
		<xsl:if test="boolean(briefdescription/*)">
            <p><xsl:apply-templates select="briefdescription"/></p>
        </xsl:if>
          <xsl:if test="boolean(detaileddescription/*)">
            <xsl:apply-templates select="detaileddescription"/>
          </xsl:if>

          <!-- prints all functions -->

          <xsl:if test="sectiondef/memberdef[@kind = &quot;function&quot;]">
            <table colsep="1" rowsep="1">
              <title>
                <xsl:text>Quick Function Reference</xsl:text>
              </title>
              <tgroup cols="3">
                <colspec colnum="1" colname="c0" colwidth="15*"/>
                <colspec colnum="2" colname="c1" colwidth="28*"/>
                <colspec colnum="3" colname="c2" colwidth="40*"/>
                <thead>
                  <row>
                    <entry>Type</entry>
                    <entry>Name</entry>
                    <entry>Arguments</entry>
                  </row>
                </thead>
                <tbody>
                  <xsl:for-each select="sectiondef/memberdef[@kind = &quot;function&quot;]">
                    <row>
                      <entry>
                        <xsl:apply-templates select="type"/>
                      </entry>
                      <entry outputclass="shaded">

                        <xref>
                          <xsl:attribute name="href">
                            <!--<xsl:text>../functions/</xsl:text>-->
                            <xsl:value-of select="@id"/>
                            <xsl:text>.xml</xsl:text>
                          </xsl:attribute>
                          <xsl:apply-templates select="name"/>
                        </xref>

                      </entry>
                      <entry>
                        <xsl:choose>
                          <xsl:when test="boolean(detaileddescription//parameterlist/parameteritem)">
                            <sl>
                              <xsl:apply-templates
                                select="detaileddescription/para/parameterlist/parameteritem"
                                mode="func_idx"/>
                            </sl>
                          </xsl:when>
                          <xsl:otherwise>
                            <sl>
                              <sli>
                                <xsl:text>void</xsl:text>
                              </sli>
                            </sl>
                          </xsl:otherwise>
                        </xsl:choose>
                      </entry>
                    </row>
                  </xsl:for-each>
                </tbody>
              </tgroup>
            </table>
          </xsl:if>

          <!-- prints all defines -->

          <xsl:if test="sectiondef/memberdef[@kind = &quot;define&quot;]">
		  <ul>
                  <xsl:for-each select="sectiondef/memberdef[@kind = &quot;define&quot;]">
 		  <li><codeph><xsl:text>#define </xsl:text>
			  <xsl:value-of select="name"/>
			  <xsl:text>    </xsl:text>
			  <xsl:apply-templates select="initializer"/></codeph>
				<xsl:if test="(boolean(briefdescription/*)) or (boolean(detaileddescription/*))">
					<xsl:apply-templates select="briefdescription"/>
					<xsl:apply-templates select="detaileddescription"/>					
				</xsl:if>			  
			  </li>
                  </xsl:for-each>



		  

		  </ul>
 <!--            <table colsep="1" rowsep="1">
              <title>
                <xsl:text>Definitions</xsl:text>
              </title>
              <tgroup cols="3">
                <colspec colnum="1" colname="c0" colwidth="15*"/>
                <colspec colnum="2" colname="c1" colwidth="28*"/>
                <colspec colnum="3" colname="c2" colwidth="40*"/>
                <thead>
                  <row>
                    <entry>Name</entry>
                    <entry>Initializer</entry>
                    <entry>Description</entry>
                  </row>
                </thead>
                <tbody>
                  <xsl:for-each select="sectiondef/memberdef[@kind = &quot;define&quot;]">
                    <row>
                      <entry>
						  <xsl:text>#define </xsl:text>
						  <xsl:value-of select="name"/>
                      </entry>
                      <entry outputclass="shaded">
						  <xsl:apply-templates select="initializer"/>
                      </entry>
                      <entry>
						<xsl:apply-templates select="briefdescription"/>
						<xsl:apply-templates select="detaileddescription"/>
						<xsl:if test="not(boolean(briefdescription/*)) and not(boolean(detaileddescription/*))">
						  <xsl:comment>This member contains no brief or detailed description.</xsl:comment>
						  <xsl:message terminate="no"> WARNING: No description added to the <xsl:value-of
							  select="name"/> definition. </xsl:message>
						</xsl:if>
                      </entry>
                    </row>
                  </xsl:for-each>
                </tbody>
              </tgroup>
            </table> -->
          </xsl:if>		  
		  
        </body>
      </topic>
    </xsl:result-document>



  </xsl:template>





  <!-- Special template for Class -->
  <xsl:template match="compounddef[@kind = &quot;class&quot;]">
    <xsl:variable name="classId" select="@id"/>
    <xsl:variable name="classMemberdefs" select="//memberdef[@kind = &quot;function&quot;]"/>
    <xsl:variable name="class_name">
      <xsl:value-of select="compoundname"/>
    </xsl:variable>
    <xsl:variable name="class_title">
      <xsl:value-of select="title"/>
    </xsl:variable>
    <xsl:variable name="filename" select="resolve-uri(concat('', $classId, '.xml'))"/>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Composite//EN"
      doctype-system="XilinxDitabase.dtd" indent="no" method="xml" href="{$filename}">

      <xsl:comment>topic <xsl:value-of select="$class_name"/></xsl:comment>
      <topic xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/">
        <xsl:attribute name="id">
          <xsl:value-of select="$classId"/>
        </xsl:attribute>
        <title>
          <xsl:value-of select="$class_name"/>
        </title>
        <xsl:if test="boolean(briefdescription/*)">
          <abstract>
            <xsl:apply-templates select="briefdescription"/>
          </abstract>
        </xsl:if>
        <body>
          <section>
            <xsl:if test="boolean(detaileddescription/*)">
              <xsl:apply-templates select="detaileddescription"/>
            </xsl:if>
          </section>
          <!-- prints all functions -->
          <xsl:if test="sectiondef/memberdef[@kind = &quot;function&quot;]">
            <section>
              <title>Quick Function Reference </title>
              <p>The following table lists all the functions defined in the <codeph><xsl:value-of
                    select="$class_name"/></codeph> class:</p>
              <table colsep="1" rowsep="1">
                <title>
                  <xsl:text>Quick Function Reference</xsl:text>
                </title>
                <tgroup cols="3">
                  <colspec colnum="1" colname="c0" colwidth="15*"/>
                  <colspec colnum="2" colname="c1" colwidth="28*"/>
                  <colspec colnum="3" colname="c2" colwidth="40*"/>
                  <thead>
                    <row>
                      <entry>Type</entry>
                      <entry>Name</entry>
                      <entry>Arguments</entry>
                    </row>
                  </thead>
                  <tbody>
                    <xsl:for-each select="sectiondef/memberdef[@kind = &quot;function&quot;]">
                      <row>
                        <entry>
                          <xsl:apply-templates select="type"/>
                        </entry>
                        <entry outputclass="shaded">

                          <xref>
                            <xsl:attribute name="href">
                              <!--<xsl:text>../functions/</xsl:text>-->
                              <xsl:value-of select="@id"/>
                              <xsl:text>.xml</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates select="name"/>
                          </xref>

                        </entry>
                        <entry>
                          <xsl:choose>
                            <xsl:when
                              test="boolean(detaileddescription//parameterlist/parameteritem)">
                              <sl>
                                <xsl:apply-templates
                                  select="detaileddescription/para/parameterlist/parameteritem"
                                  mode="func_idx"/>
                              </sl>
                            </xsl:when>
                            <xsl:otherwise>
                              <sl>
                                <sli>
                                  <xsl:text>void</xsl:text>
                                </sli>
                              </sl>
                            </xsl:otherwise>
                          </xsl:choose>
                        </entry>
                      </row>
                    </xsl:for-each>
                  </tbody>
                </tgroup>
              </table>
            </section>
          </xsl:if>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>











  <xsl:template match="initializer">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="name">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Special template for structures -->
  <xsl:template match="compounddef[@kind = &quot;struct&quot;]">
    <xsl:variable name="struct_name">
      <xsl:value-of select="compoundname"/>
    </xsl:variable>
    <xsl:variable name="struct_id">
      <xsl:value-of select="@id"/>
    </xsl:variable>

    <xsl:variable name="filename" select="resolve-uri(concat('', $struct_id, '.xml'))"/>
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Topic//EN"
      doctype-system="XilinxDitabase.dtd" indent="no" method="xml" href="{$filename}">
      <xsl:comment>topic <xsl:value-of select="$struct_name"/></xsl:comment>
      <topic xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/">
        <xsl:attribute name="id">
          <xsl:value-of select="$struct_id"/>
        </xsl:attribute>
        <title>
          <xsl:value-of select="$struct_name"/>
        </title>
        <xsl:if test="boolean(briefdescription/*)">
          <abstract>
            <xsl:apply-templates select="briefdescription"/>
          </abstract>
        </xsl:if>
        <body>
          <xsl:if test="boolean(detaileddescription/*)">
            <xsl:apply-templates select="detaileddescription"/>
          </xsl:if>
          <xsl:if test="sectiondef/memberdef">
            <p>
              <b>
                <xsl:text>Declaration</xsl:text>
              </b>
            </p>
            <codeblock>
              <xsl:text>typedef struct
{
</xsl:text>
              <xsl:for-each select="sectiondef/memberdef">
                <xsl:text>  </xsl:text>
                <xsl:apply-templates select="type"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="name"/>
                <xsl:if test="boolean(argstring/text())">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="argsstring"/>
                <xsl:if test="position() != count(../memberdef)">
                  <xsl:text>,</xsl:text>
                  <xsl:text>
</xsl:text>
                  <!-- Do not indent this, it produces a new line (only) -->
                </xsl:if>
              </xsl:for-each>
              <xsl:text>
} </xsl:text>
              <xsl:value-of select="$struct_name"/>
              <xsl:text>;</xsl:text>
            </codeblock>
            <table colsep="1" rowsep="1">
              <title>
                <xsl:text>Structure </xsl:text>
                <xsl:value-of select="$struct_name"/>
                <xsl:text> member description</xsl:text>
              </title>
              <tgroup cols="2">
                <colspec colnum="1" colname="c0" colwidth="2*"/>
                <colspec colnum="2" colname="c1" colwidth="3*"/>
                <thead>
                  <row>
                    <entry>Member</entry>
                    <entry>Description</entry>
                  </row>
                </thead>
                <tbody>
                  <xsl:for-each select="sectiondef/memberdef">
                    <row>
                      <entry>
                        <xsl:apply-templates select="name"/>
                      </entry>
                      <entry>
                        <xsl:apply-templates select="briefdescription"/>
                        <xsl:apply-templates select="detaileddescription"/>
                        <xsl:if
                          test="not(boolean(briefdescription/*)) and not(boolean(detaileddescription/*))">
                          <xsl:comment>This member contains no brief or detailed description.</xsl:comment>
                          <xsl:message terminate="no"> WARNING: No description added to
                              <xsl:value-of select="name"/> in structure <xsl:value-of
                              select="ancestor::compounddef/compoundname"/>
                          </xsl:message>
                        </xsl:if>
                      </entry>
                    </row>
                  </xsl:for-each>
                </tbody>
              </tgroup>
            </table>
          </xsl:if>
          <xsl:call-template name="process_remarks"/>
        </body>
      </topic>
      <xsl:apply-templates select="innergroup | innerclass"/>
    </xsl:result-document>
  </xsl:template>
  <xsl:template match="argsstring">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Generation of function parameters _ one parameter description -->
  <xsl:template match="parameteritem">
    <xsl:variable name="current_parameter" select="parameternamelist/parametername"/>
    <xsl:variable name="current_parameter_direction"
      select="parameternamelist/parametername/attribute::direction"/>
    <row>
      <!-- type -->
      <entry>
        <xsl:choose>
          <xsl:when test="boolean((ancestor::memberdef)//param[declname = $current_parameter]/type)">
            <xsl:apply-templates
              select="(ancestor::memberdef)//param[declname = $current_parameter]/type"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="no"> WARNING: Commented parameter <xsl:value-of
                select="$current_parameter"/> does not exist in function <xsl:value-of
                select="(ancestor::memberdef)/name"/>. </xsl:message> Commented parameter
              <xsl:value-of select="$current_parameter"/> does not exist in function <xsl:value-of
              select="(ancestor::memberdef)/name"/>. <xsl:comment>
              </xsl:comment>
          </xsl:otherwise>
        </xsl:choose>
      </entry>
      <!-- name -->
      <entry>
        <xsl:apply-templates select="parameternamelist/parametername"/>
      </entry>
      <!-- description -->
      <entry>
        <xsl:apply-templates select="parameterdescription"/>
      </entry>
    </row>
  </xsl:template>


  <xsl:template match="type">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="parametername">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="parameterdescription">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Templates for content filling -->

  <!-- very simple rule for images - this needsto be improved
       * does not copy files
       * works only with .png files used in html
       * each .png has to have .svg with the same name in the (generated)../images directory -->
  <xsl:template match="image[@type = &quot;html&quot;]">
    <xsl:variable name="image_svg">
      <xsl:value-of select="concat(substring-before(@name, &quot;.png&quot;), &quot;.svg&quot;)"/>
    </xsl:variable>
    <fig>
      <xsl:if test="boolean(./text())">
        <title>
          <xsl:value-of select="."/>
        </title>
      </xsl:if>
      <image>
        <xsl:attribute name="href">../images/<xsl:value-of select="$image_svg"/></xsl:attribute>
        <xsl:attribute name="align">center</xsl:attribute>
        <xsl:attribute name="placement">break</xsl:attribute>
        <alt>Image <xsl:value-of select="$image_svg"/></alt>
      </image>
    </fig>
  </xsl:template>
  
  <!-- Template to generate image element -->
  <xsl:template match="image[@type = &quot;latex&quot;]">
    <xsl:variable name="image_name">
      <xsl:value-of select="@name"/>
    </xsl:variable>
    <fig>
      <xsl:if test="boolean(./text())">
        <title>
          <xsl:value-of select="."/>
        </title>
      </xsl:if>
      <image>
        <xsl:attribute name="href"><xsl:value-of select="$image_name"/></xsl:attribute>
        <xsl:attribute name="align">center</xsl:attribute>
        <xsl:attribute name="placement">break</xsl:attribute>
        <alt>Image <xsl:value-of select="$image_name"/></alt>
      </image>
    </fig>
  </xsl:template>


  <!-- Ulink -->
  <xsl:template match="ulink">
  
   <xref>
    <xsl:attribute name="href">
     <xsl:value-of select="@url"/>
      </xsl:attribute>
	 <xsl:attribute name="format">
     <xsl:text>html</xsl:text>
      </xsl:attribute>  
	 	 <xsl:attribute name="scope">
     <xsl:text>external</xsl:text>
      </xsl:attribute>  
      <xsl:apply-templates/>
    </xref>  
  </xsl:template>
  

  
  <!-- Italic text -->
  <xsl:template match="emphasis">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  
  <!-- Computer output text template -->
  <xsl:template match="computeroutput">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Brief description text paragraph -->
  <xsl:template match="briefdescription">
    <xsl:apply-templates/>
  </xsl:template>
 
  <!-- Detailed description text paragraph -->
  <xsl:template match="detaileddescription">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Inbody comment description text paragraph -->
  <xsl:template match="inbodydescription">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Text paragraph -->
  <xsl:template match="para">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Only few tags are possible in body tag, this wraps the other into p tag
       wrapped tags are: ref(xref), bold(b) -->
  <xsl:template match="detaileddescription/para">
    <xsl:if test="boolean(text() | ref | bold | emphasis | computeroutput)">
      <p>
        <xsl:apply-templates select="text() | ref | bold | emphasis | computeroutput"/>
      </p>
    </xsl:if>
    <xsl:apply-templates
      select="
        child::*[name(.) != &quot;ref&quot; and name(.) != &quot;bold&quot;
        and name(.) != &quot;emphasis&quot; and name(.) != &quot;computeroutput&quot;]"
    />
  </xsl:template>

  <!-- Template to create sections in a topic -->
  <xsl:template match="detaileddescription/sect1">
      <section>
	  <title><xsl:value-of select="title"/></title>
        <p><xsl:apply-templates/></p>
      </section>
  </xsl:template>
  
    <xsl:template match="detaileddescription/sect1/para/computeroutput">
      <codeph>
	 <xsl:apply-templates/>
      </codeph>
  </xsl:template>
  
      <xsl:template match="detaileddescription/sect1/para/orderedlist/listitem/para/computeroutput">
      <codeph>
	 <xsl:apply-templates/>
      </codeph>
  </xsl:template>
  
    <!-- Template to create sections in a topic -->
  <xsl:template match="detaileddescription/sect1/sect2">
      <section>
	  <xsl:comment>[atalwar] This section was not defined correctly in the code. DITA does not support nested sections. Use first level section headings only.</xsl:comment>
	  <title><xsl:value-of select="title"/></title>
        <p><xsl:apply-templates/></p>
      </section>
  </xsl:template>

    <xsl:template match="detaileddescription/sect1/sect2/para/computeroutput">
      <codeph>
	 <xsl:apply-templates/>
      </codeph>
  </xsl:template>
  
      <xsl:template match="detaileddescription/sect1/sect2/para/orderedlist/listitem/para/computeroutput">
      <codeph>
	 <xsl:apply-templates/>
      </codeph>
  </xsl:template>
  
  <xsl:template match="text()">
    <!-- <xsl:value-of select="normalize-space(.)"/> spaces removal causes that tagged word is not spaced from other text e.g. xref -->
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- Generate lists, only tags are replaced -->
  <xsl:template match="itemizedlist">
    <ul>
      <xsl:apply-templates select="listitem"/>
    </ul>
  </xsl:template>
  
  <!-- Generate ordered lists -->
  <xsl:template match="orderedlist">
    <ol>
      <xsl:apply-templates select="listitem"/>
    </ol>
  </xsl:template>
  
  <!-- Generate unordered lists -->
  <xsl:template match="listitem">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <!-- Simplesects generated as paragraph with label (user defined) 
       * output is a paragraph with bold underlined heading -->
  <xsl:template match="simplesect[@kind = &quot;par&quot;]">
    <p>
      <xsl:if test="boolean(title/text())">
        <u>
          <b>
            <xsl:value-of select="title"/>
          </b>
        </u>
        <b>
          <xsl:text>: </xsl:text>
        </b>
      </xsl:if>
      <xsl:apply-templates select="para"/>
    </p>
  </xsl:template>
  <!-- Simlesects of predefined type (built-in in doxygen) 
        * each type has different output (mostly paragraph with capitalized type as bold and underlined heading)-->
  <xsl:template match="simplesect">
    <xsl:choose>
      <xsl:when test="@kind = &quot;warning&quot;">
        <note type="caution">
          <xsl:apply-templates/>
        </note>
      </xsl:when>
      <xsl:when test="@kind = &quot;note&quot;">
        <note type="note">
          <xsl:apply-templates/>
        </note>
      </xsl:when>
      <!-- Intentionally commented out, returns are processed separately -->
      <xsl:when test="@kind = &quot;return&quot;">
        <!-->  <section>
		<title>Return</title>
          <xsl:apply-templates/>
        </section> <-->
      </xsl:when>
      <!-- Intentionally commented out, remarks are processed separately -->
      <xsl:when test="@kind = &quot;remark&quot;">
        <!-->      <p>
          <u>
            <b>
              <xsl:text>Remark</xsl:text>
            </b>
          </u>
          <b>
            <xsl:text>: </xsl:text>
          </b>
          <xsl:apply-templates select="child::*"/>
        </p> <-->
      </xsl:when>
      <xsl:otherwise>
        <p>
              <xsl:value-of select="@kind"/>
              <xsl:text>:</xsl:text>
              <xsl:text>: </xsl:text>
          
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Anchor=link target 
       * TODO: find better solution (put empty ph with ID and link it?)
       * works automatically because xref searches for parent node generating a topic -->
  <xsl:template match="anchor">
    <xsl:comment>ANCHOR HERE</xsl:comment>
  </xsl:template>

  <!-- Template to generate references -->
  <xsl:template match="ref">
    <xref>
      <xsl:attribute name="href">
        <xsl:value-of select="@refid"/>
        <xsl:text>.xml</xsl:text>
      </xsl:attribute>
      <codeph>
        <xsl:value-of select="."/>
      </codeph>
    </xref>
  </xsl:template>

  <!-- Code samples -->
  <xsl:template match="programlisting">
    <codeblock>
      <xsl:apply-templates/>
    </codeblock>
  </xsl:template>
  <xsl:template match="codeline">
    <!-- create newline with current encoding -->
    <xsl:if test="position() > 1">
      <xsl:text>
</xsl:text>
      <!-- do not indent this tag -->
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="highlight">
    <xsl:if test="boolean(child::* | child::text())">
      <xsl:choose>
        <xsl:when test="@class = &quot;normal&quot;">
          <!-- normal does nothing -->
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="@class = &quot;preprocessor&quot;">
          <codeph>
            <xsl:apply-templates/>
          </codeph>
        </xsl:when>
        <xsl:when test="@class = &quot;comment&quot;">
          <codeph>
            <xsl:apply-templates/>
          </codeph>
        </xsl:when>
        <xsl:when test="@class = &quot;keyword&quot;">
          <codeph>
            <xsl:apply-templates/>
          </codeph>
        </xsl:when>
        <xsl:when test="@class = &quot;keywordtype&quot;">
          <codeph>
            <xsl:apply-templates/>
          </codeph>
        </xsl:when>
        <xsl:when test="@class = &quot;keywordflow&quot;">
          <codeph>
            <xsl:apply-templates/>
          </codeph>
        </xsl:when>

        <!-- TODO some styles may be missing, add them -->
        <xsl:otherwise>
          <xsl:comment> Highlight class <xsl:value-of select="@class"/> is missing in the template .</xsl:comment>
          <xsl:message terminate="no"> Warning: Highlight class <xsl:value-of select="@class"/> is
            missing in the template. </xsl:message>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="sp">
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Template to generate Tables documented in markdown in source code-->
  <xsl:template match="table">
    <table colsep="1" rowsep="1">
      <xsl:if test="boolean(caption)">
        <title>
          <xsl:value-of select="caption"/>
        </title>
      </xsl:if>
      <tgroup>
        <xsl:attribute name="cols">
          <xsl:value-of select="@cols"/>
        </xsl:attribute>
        <!-- TODO How to put @cols * <colspec colnum="number" colname="some_id" colwidth="1*">  -->
        
        <!-- support for table headers -->
        <xsl:if test="row/entry[@thead = &quot;yes&quot;]">
          <thead>
            <row>
              <xsl:apply-templates select="row/entry[@thead = &quot;yes&quot;]"/>
            </row>
          </thead>
        </xsl:if>
        <tbody>
          <xsl:apply-templates select="row"/>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>
  
  <!-- Template to generate table tbody rows -->
  <xsl:template match="row">
    <xsl:if test="entry[@thead = &quot;no&quot;]">
      <row>
        <xsl:apply-templates select="entry[@thead = &quot;no&quot;]"/>
      </row>
    </xsl:if>
  </xsl:template>
 
  <!-- Template to generate a table entry for all header information --> 
  <xsl:template match="entry[@thead = &quot;yes&quot;]">
    <entry>
      <xsl:apply-templates/>
    </entry>
  </xsl:template>
  
 <!-- Template to generate a table entry for all non-header information -->
  <xsl:template match="entry[@thead = &quot;no&quot;]">
    <entry>
      <xsl:apply-templates/>
    </entry>
  </xsl:template>

  <!-- copydoc - Doxygen copy of the documentation -->
  <xsl:template match="copydoc">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- Generate a list entry of each structure that needs to be exposed. -->
  <xsl:template match="compounddef" mode="struct_idx">
    <li>
      <xref>
        <xsl:attribute name="href">
          <xsl:value-of select="@id"/>
          <xsl:text>.xml</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="name"/>
      </xref>
    </li>
  </xsl:template>


  <!-- Generate a table row listing all the functions in the API document. This template is not used any more. -->
  <xsl:template match="memberdef" mode="func_idx">
    <row>
      <entry>
        <xsl:apply-templates select="type"/>
      </entry>
      <entry outputclass="shaded">
        <b>
          <xref>
            <xsl:attribute name="href">
              <xsl:text>functions/</xsl:text>
              <xsl:value-of select="name"/>
              <xsl:text>.xml</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="name"/>
          </xref>
        </b>
      </entry>
      <entry>
        <xsl:choose>
          <xsl:when test="boolean(detaileddescription//parameterlist/parameteritem)">
            <sl>
              <xsl:apply-templates select="detaileddescription/para/parameterlist/parameteritem"
                mode="func_idx"/>
            </sl>
          </xsl:when>
          <xsl:otherwise>
            <sl>
              <sli>
                <xsl:text>void</xsl:text>
              </sli>
            </sl>
          </xsl:otherwise>
        </xsl:choose>
      </entry>
    </row>
  </xsl:template>


  <!-- Generate table row listing functions grouped as a part of a defined group. The information is added to the group index page. -->

  <xsl:template match="sectiondef" mode="grp_idx">
    <row>
      <entry>
        <xsl:apply-templates select="type"/>
      </entry>
      <entry outputclass="shaded">

        <xref>
          <xsl:attribute name="href">
            <xsl:value-of select="name"/>
            <xsl:text>.xml</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates select="name"/>
        </xref>

      </entry>
      <entry>
        <xsl:choose>
          <xsl:when test="boolean(detaileddescription//parameterlist/parameteritem)">
            <sl>
              <xsl:apply-templates select="detaileddescription/para/parameterlist/parameteritem"
                mode="func_idx"/>
            </sl>
          </xsl:when>
          <xsl:otherwise>
            <sl>
              <sli>
                <xsl:text>void</xsl:text>
              </sli>
            </sl>
          </xsl:otherwise>
        </xsl:choose>
      </entry>
    </row>
  </xsl:template>

  <!-- Generate a table list member of the function parameter. Uses <sli> element for listing parameter item. -->
  <xsl:template match="parameteritem" mode="func_idx">
    <xsl:variable name="current_parameter" select="parameternamelist/parametername"/>
    <xsl:variable name="current_parameter_direction"
      select="parameternamelist/parametername/attribute::direction"/>
    <!-- type -->
    <sli>
      <xsl:if test="boolean((ancestor::memberdef)//param[declname = $current_parameter]/type)">
        <xsl:apply-templates
          select="(ancestor::memberdef)//param[declname = $current_parameter]/type"/>
      </xsl:if>
      <xsl:text> </xsl:text>
      <!-- name -->
      <xsl:apply-templates select="parameternamelist/parametername"/>
    </sli>
  </xsl:template>

  <!-- Generate table row entry for macro index member -->
  <xsl:template match="memberdef" mode="macro_idx">
    <row>
      <entry>
        <codeph>
            <xsl:text>#define </xsl:text>
          <xref>
            <xsl:attribute name="href">
              <xsl:value-of select="concat(generate-id(.), '.xml')"/>
            </xsl:attribute>
            <xsl:value-of select="name"/>
          </xref>
          <xsl:text>    </xsl:text>
          <xsl:apply-templates select="initializer"/>
        </codeph>
      </entry>
    </row>
  </xsl:template>
  
  <!-- Generate content for remarks -->
  <xsl:template name="process_remarks">
    <xsl:if test="boolean(descendant::simplesect[@kind = &quot;remark&quot;])">
      <ul>
        <xsl:for-each select="descendant::simplesect[@kind = &quot;remark&quot;]/para">
          <li>
            <xsl:apply-templates select="."/>
          </li>
        </xsl:for-each>
      </ul>

    </xsl:if>
  </xsl:template>



  <!-- Generate content for returns -->
  <xsl:template name="process_returns">
    <xsl:if test="boolean(descendant::simplesect[@kind = &quot;returns&quot;])">
      <xsl:apply-templates select="child::*"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
