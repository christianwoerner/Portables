<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ows="http://www.opengis.net/ows"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink>"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:template match="/wfs:WFS_Capabilities | /WFS_Capabilities">
    <html>
      <head>
        <link href="##DATAPATH##capability.css" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <xsl:call-template name="ServiceTitle"/>
        <xsl:call-template name="ServiceInfo"/>
        <xsl:call-template name="ServiceContact"/>
        <xsl:call-template name="Statistics"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="wfs:xxxWFS_Capabilities">
    <h1>
      <xsl:value-of select="wfs:Service/wfs:Title" />
    </h1>
    <h2>
      <xsl:value-of select="wfs:Service/wfs:OnlineResource" />
    </h2>
    <p>
      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </p>
    <xsl:apply-templates select="//wfs:ServiceContact" />
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <h3>Service-Info</h3>
    <table class="service">
      <tr>
        <th>Name</th>
        <td>
          <xsl:value-of select="wfs:Service/wfs:Name" />
        </td>
      </tr>
      <xsl:if test="count(wfs:Service/wfs:Abstract) != 0">
        <tr>
          <th>Abstract</th>
          <td>
            <xsl:value-of select="wfs:Service/wfs:Abstract" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(wfs:Service/wfs:Keywords) != 0">
        <tr>
          <th>Schlüsselwörter</th>
          <td>
            <xsl:for-each select="wfs:Service/wfs:Keywords/wfs:Keyword">
              <xsl:value-of select="."/>,
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(wfs:Service/wfs:Fees) != 0">
        <tr>
          <th>Gebühren</th>
          <td>
            <xsl:value-of select="wfs:Service/wfs:Fees" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(wfs:Service/wfs:AccessConstraints) != 0">
        <tr>
          <th>Beschränkungen</th>
          <td>
            <xsl:value-of select="wfs:Service/wfs:AccessConstraints" />
          </td>
        </tr>
      </xsl:if>
      <tr>
        <th>Schema</th>
        <td>
          <xsl:value-of select="name(/*)"/>
          (Version <xsl:value-of select="/*/@version"/>)
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="ServiceTitle">
    <h1>
      <xsl:value-of select="Service/Title" />
      <xsl:value-of select="wfs:Service/wfs:Title" />
    </h1>
    <h2>
      <xsl:value-of select="Service/OnlineResource" />
      <xsl:value-of select="wfs:Service/wfs:OnlineResource" />
    </h2>
    <p>
      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </p>
  </xsl:template>

  <xsl:template name="ServiceInfo">
    <xsl:if test="Service | wfs:Service">
      <h3>Service-Info</h3>
      <table class="service">
        <tr>
          <th>Name</th>
          <td>
            <xsl:value-of select="Service/Name" />
            <xsl:value-of select="wfs:Service/wfs:Name" />
          </td>
        </tr>
        <xsl:if test="count(Service/Abstract) + count(wfs:Service/wfs:Abstract)">
          <tr>
            <th>Abstract</th>
            <td>
              <xsl:value-of select="Service/Abstract" />
              <xsl:value-of select="wfs:Service/wfs:Abstract" />
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="count(Service/Keywords) + count(wfs:Service/wfs:Keywords)">
          <tr>
            <th>Schlüsselwörter</th>
            <td>
              <xsl:for-each select="Service/Keywords/Keyword | wfs:Service/wfs:Keywords/wfs:Keyword">
                <xsl:value-of select="."/>,
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="count(Service/Fees) + count(wfs:Service/wfs:Fees)">
          <tr>
            <th>Gebühren</th>
            <td>
              <xsl:value-of select="Service/Fees" />
              <xsl:value-of select="wfs:Service/wfs:Fees" />
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="count(Service/AccessConstraints) + count(wfs:Service/wfs:AccessConstraints)">
          <tr>
            <th>Beschränkungen</th>
            <td>
              <xsl:value-of select="Service/AccessConstraints" />
              <xsl:value-of select="wfs:Service/wfs:AccessConstraints" />
            </td>
          </tr>
        </xsl:if>
        <tr>
          <th>Schema</th>
          <td>
            <xsl:value-of select="name(/*)"/>
            (Version <xsl:value-of select="/*/@version"/>)
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ServiceContact">
    <xsl:if test="ServiceContact | wfs:ServiceContact">
      <h3>Kontakt</h3>
      <table class="person">
        <tr>
          <th>Kontaktperson</th>
          <td>
            <xsl:value-of select="ServiceContact/IndividualName"/>
            <br/>
            <xsl:value-of select="ProviderName"/>
            <br/>
            <xsl:value-of select="ServiceContact/PositionName"/>
          </td>
        </tr>
        <tr>
          <th>Anschrift</th>
          <td>
            <xsl:value-of select="ServiceContact/ContactInfo/Address/DeliveryPoint"/>
            <br/>
            <xsl:value-of select="ServiceContact/ContactInfo/Address/PostalCode"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="ServiceContact/ContactInfo/Address/City"/>
            <br/>
            <xsl:value-of select="ServiceContact/ContactInfo/Address/Country"/>
            <br/>
          </td>
        </tr>
        <tr>
          <th>Telefon</th>
          <td>
            <xsl:value-of select="ServiceContact/ContactInfo/Phone/Voice"/>
          </td>
        </tr>
        <tr>
          <th>Fax</th>
          <td>
            <xsl:value-of select="ServiceContact/ContactInfo/Phone/Facsimile"/>
          </td>
        </tr>
        <tr>
          <th>E-Mail</th>
          <td>
            <xsl:value-of select="ServiceContact/ContactInfo/Address/ElectronicMailAddress"/>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Statistics">
    <h3>Statistik</h3>
    <table class="statistics">
      <tr>
        <th>
          Unterstützte Requests (<xsl:value-of select="count(//Capability/Request/*) + count(//wfs:Capability/wfs:Request/*)"/>)
        </th>
        <td>
          <xsl:if test="count(//Capability/Request/*) + count(//wfs:Capability/wfs:Request/*)">
            <xsl:for-each select="//Capability/Request/* | //wfs:Capability/wfs:Request/*">
              <xsl:value-of select="name()"/>
              <br/>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <th>
          Feature Types (<xsl:value-of select="count(//FeatureType) + count(//wfs:FeatureType)"/>)
        </th>
        <td>
          <xsl:if test="count(//FeatureType) + count(//wfs:FeatureType)">
            <xsl:for-each select="//FeatureType | //wfs:FeatureType">
              <xsl:value-of select="Name | wfs:Name"/>
              <br/>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
