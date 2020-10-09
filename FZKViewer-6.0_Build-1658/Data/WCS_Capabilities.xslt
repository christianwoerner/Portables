<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:wcs="http://www.opengis.net/wcs"
    xmlns:ows="http://www.opengis.net/ows"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink>"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:template match="/wcs:WCS_Capabilities | /WCS_Capabilities">
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

  <xsl:template name="ServiceTitle">
    <h1>
      <xsl:value-of select="Service/label" />
      <xsl:value-of select="wcs:Service/wcs:label" />
    </h1>
    <h2>
      <xsl:value-of select="Service/responsibleParty/contactInfo/onlineResource/@xlink:href" />
      <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:onlineResource/@xlink:href" />
    </h2>
    <p>
      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </p>
  </xsl:template>

  <xsl:template name="ServiceInfo">
    <xsl:if test="Service | wcs:Service">
      <h3>Service-Info</h3>
      <table class="service">
        <tr>
          <th>Name</th>
          <td>
            <xsl:value-of select="Service/name" />
            <xsl:value-of select="wcs:Service/wcs:name" />
          </td>
        </tr>
        <xsl:if test="count(Service/description) + count(wcs:Service/wcs:description)">
          <tr>
            <th>Abstract</th>
            <td>
              <xsl:value-of select="Service/description" />
              <xsl:value-of select="wcs:Service/wcs:description" />
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="count(Service/keywords) + count(wcs:Service/wcs:keywords)">
          <tr>
            <th>Schlüsselwörter</th>
            <td>
              <xsl:for-each select="Service/keywords/keyword | wcs:Service/wcs:keywords/wcs:keyword">
                <xsl:value-of select="."/>,
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="count(Service/fees) + count(wcs:Service/wcs:fees)">
          <tr>
            <th>Gebühren</th>
            <td>
              <xsl:value-of select="Service/fees" />
              <xsl:value-of select="wcs:Service/wcs:fees" />
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="count(Service/accessConstraints) + count(wcs:Service/wcs:accessConstraints)">
          <tr>
            <th>Beschränkungen</th>
            <td>
              <xsl:value-of select="Service/accessConstraints" />
              <xsl:value-of select="wcs:Service/wcs:accessConstraints" />
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
    <xsl:if test="Service/responsibleParty | wcs:Service/wcs:responsibleParty">
      <h3>Kontakt</h3>
      <table class="person">
        <tr>
          <th>Kontaktperson</th>
          <td>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:individualName"/>
            <br/>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:organisationName"/>
            <br/>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:positionName"/>
          </td>
        </tr>
        <tr>
          <th>Anschrift</th>
          <td>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:address/wcs:deliveryPoint"/>
            <br/>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:address/wcs:postalCode"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:address/wcs:city"/>
            <br/>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:address/wcs:country"/>
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:address/wcs:administrativeArea"/>
            <br/>
          </td>
        </tr>
        <tr>
          <th>Telefon</th>
          <td>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:phone/wcs:voice"/>
          </td>
        </tr>
        <tr>
          <th>Fax</th>
          <td>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:phone/wcs:facsimile"/>
          </td>
        </tr>
        <tr>
          <th>E-Mail</th>
          <td>
            <xsl:value-of select="wcs:Service/wcs:responsibleParty/wcs:contactInfo/wcs:address/wcs:electronicMailAddress"/>
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
          Unterstützte Requests (<xsl:value-of select="count(//Capability/Request/*) + count(//wcs:Capability/wcs:Request/*)"/>)
        </th>
        <td>
          <xsl:if test="count(//Capability/Request/*) + count(//wcs:Capability/wcs:Request/*)">
            <xsl:for-each select="//Capability/Request/* | //wcs:Capability/wcs:Request/*">
              <xsl:value-of select="name()"/>
              <br/>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <th>
          Coverage (<xsl:value-of select="count(//CoverageOfferingBrief) + count(//wcs:CoverageOfferingBrief)"/>)
        </th>
        <td>
          <xsl:if test="count(//CoverageOfferingBrief) + count(//wcs:CoverageOfferingBrief)">
            <xsl:for-each select="//CoverageOfferingBrief | //wcs:CoverageOfferingBrief">
              <xsl:value-of select="name | wcs:name"/>
              <xsl:if test="label | wcs:label">
                (<xsl:value-of select="label | wcs:label"/>)
              </xsl:if>
              <br/>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
