xquery version '3.0' ;
module namespace nee.models.tei = 'nee.models.tei' ;

(:~
 : This module is for TEI models
 :
 : @version 2.0 (Constantia edition)
 : @since 2014-11-10 
 : @author synopsx team
 :
 : This file is part of SynopsX.
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 : SynopsX is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : SynopsX is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 : See the GNU General Public License for more details.
 : You should have received a copy of the GNU General Public License along 
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../../../models/tei.xqm' ;
declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace "nee.models.tei";





(:~
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getTextsList($queryParams as map(*)) as map(*) {
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:TEI
  let $meta := map{
    'title' : 'Liste des textes', 
    'quantity' : getQuantity($texts, ' texte'),
    'author' : getAuthors($texts),
    'copyright'  : getCopyright($texts),
    'description' : getAbstract($texts),
    'keywords' : getKeywords($texts)
    }
  let $content := for $text in $texts return getHeader($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getVolList($queryParams as map(*)) as map(*) {
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:TEI
  let $meta := map{
    'title' : 'Liste des volumes'
    }
  let $content := for $text in $texts return getVol($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getVolListbyyear($queryParams as map(*)) as map(*) {
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:TEI
  let $meta := map{
    'title' : 'Liste des volumes par annee'
    }
  let $content := for $text in $texts return getVolbyyear($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getCorpusList($queryParams as map(*)) as map(*) {
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:teiCorpus
  let $meta := map{
    'title' : 'Liste des corpus', 
    'quantity' : getQuantity($texts, ' texte'),
    'author' : getAuthors($texts),
    'copyright'  : getCopyright($texts),
    'description' : getAbstract($texts),
    'keywords' : getKeywords($texts)
    }
  let $content := for $text in $texts return getHeader($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getTextById($queryParams as map(*)) as map(*) {
  let $text := synopsx.lib.commons:getDb($queryParams)//tei:TEI[@xml:id=map:get($queryParams, 'id')]
  let $meta := map{
    'title' : getTitles($text), 
    'quantity' : getQuantity($text, ' texte'),
    'author' : getAuthors($text),
    'copyright'  : getCopyright($text),
    'description' : getAbstract($text),
    'keywords' : getKeywords($text)
    }
  let $content :=  getText($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getIssueById($queryParams as map(*)) as map(*) {
  let $text := synopsx.lib.commons:getDb($queryParams)//tei:div[@type='numero'][@xml:id=map:get($queryParams, 'id')]
  let $meta := map{
    'title' : getTitles($text), 
    'quantity' : getQuantity($text, ' texte'),
    'author' : getAuthors($text),
    'copyright'  : getCopyright($text),
    'description' : getAbstract($text),
    'keywords' : getKeywords($text)
    }
  let $content :=  getIssue($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getBiblList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:bibl
  let $meta := map{
    'title' : 'Bibliographie'
    }
  let $content := for $item in $texts return getBibl($item)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getDivList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:div[@type="numero"]
  let $meta := map{
    'title' : 'Liste des numeros'
    }
  let $content := for $item in $texts order by $item/tei:head[@type="numero_titre"] return getDiv($item)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};


(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getRespList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:respStmt
  let $meta := map{
    'title' : 'Responsables de l édition'
    }
  let $content := for $item in $texts return getResp($item)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getText($item as element()) {
  map {
    'title' : getTitles($item/tei:teiHeader),
    'date' : getDate($item/tei:teiHeader),
    'author' : getAuthors($item/tei:teiHeader),
    'tei' : $item
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getIssue($item as element()) {
  map {
    'title' : $item/tei:head[@type='numero_titre'],
    'numero' : $item/tei:head[@type='numero_numero'],
	'precedent' : getPrevious($item/preceding::tei:div[@type='numero'][1]),
	'suivant' : getNext($item/following::tei:div[@type='numero'][1]),
	'issueyear' : $item/ancestor::tei:text//tei:titlePart[@type='annee'],
	'issuevol' : $item/ancestor::tei:text//tei:titlePart[@type='tome'],
	'issuepartnumber' : $item/ancestor::tei:div[@type='partie']/tei:head[@type='partie_numero'],
	'issueparttitle' : $item/ancestor::tei:div[@type='partie']/tei:head[@type='partie_titre'],
    'tei' : $item
  }
};


declare function getPrevious($content as element()*){
  fn:string-join(
    for $previous in $content/@xml:id
    return fn:normalize-space($previous),
    '.html')
};

declare function getNext($content as element()*){
  fn:string-join(
    for $next in $content/@xml:id
    return fn:normalize-space($next),
    '.html')
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getHeader($item as element()) {
   map {
    'title' : getTitles($item/tei:teiHeader),
    'date' : getDate($item/tei:teiHeader),
    'author' : getAuthors($item/tei:teiHeader),
    'url' : getUrl($item),
    'tei' : getAbstract($item/tei:teiHeader)
  }
};

declare function getUrl($content as element()*){
  fn:string-join(
    for $url in $content/@xml:id
    return fn:normalize-space($url),
    '.html')
};


(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getVol($item as element()) {
   map {
    'volyear' : getVolYear($item/tei:teiHeader)
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getVolbyyear($item as element()) {
   map {
    'volyeartitle' : getVolbyyeartitle($item/tei:teiHeader)
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getBibl($item as element()) {
  map {
    'title' : getBiblTitles($item),
    'date' : getBiblDate($item),
    'author' : getBiblAuthors($item),
    'tei' : $item
  }
};

(:~
 : NEE project
 : this function creates a map for a div item
 :
 : @param $item a div item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getDiv($item as element()) {
  map {
    'title' : getDivTitles($item),
    'url' : getDivUrl($item),
    'year' : getDivDate($item),
	'volume' : getDivVolume($item),
    'issue' : getDivIssue($item),
	'part' : getDivPart($item),
    'tei' : $item
  }
};


declare function getDivUrl($content as element()*){
  fn:string-join(
    for $url in $content/@xml:id
    return fn:normalize-space($url),
    '.html')
};



(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getResp($item as element()) {
  map {
    'name' : getName($item),
    'resp' : $item//tei:resp
  }
};




(:~
 : ~:~:~:~:~:~:~:~:~
 : tei builders
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getTitles($content as element()*){
  fn:string-join(
    for $title in $content//tei:titleStmt//tei:title
    return fn:string-join($title), ', ')
};

(:~
 : this function get titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getBiblTitles($content as element()*){
  fn:string-join(
    for $title in $content//tei:title
    return fn:normalize-space($title),
    ', ')
};

(:~
 : this function get titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getDivTitles($content as element()*){
  fn:string-join(
    for $div in $content//tei:head[@type="numero_titre"]
    return fn:normalize-space($div),
    ', ')
};


(:~
 : this function get issues
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getDivIssue($content as element()*){
  fn:string-join(
    for $issue in $content//tei:head[@type="numero_numero"]
    return fn:normalize-space($issue),
    ', ')
};

(:~
 : NEE project : this function get parts
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getDivPart($content as element()*){
  fn:string-join(
    for $part in $content//ancestor::tei:div[@type="partie"]/tei:head[@type="partie_numero"]
    return fn:normalize-space($part),
    ', ')
};




(:~
 : NEE project : this function get volumes
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getDivVolume($content as element()*){
  fn:string-join(
    for $volume in $content//ancestor::tei:TEI//tei:biblScope[@unit="volume"]
    return fn:normalize-space($volume),
    ', ')
};



(:~
 : NEE project : this function get year
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getDivDate($content as element()*){
  fn:string-join(
    for $year in $content//ancestor::tei:TEI//tei:bibl/tei:date
    return fn:normalize-space($year),
    ', ')
};


(:~
 : this function get abstract
 : @param $content texts to process
 : @return a tei abstract
 :)
declare function getAbstract($content as element()*){
   fn:string-join(
    for $abstract in $content//tei:projectDesc
    return fn:normalize-space($abstract),
    ' ')
};

(:~
 : NEE project
 : this function creates a map for a div item
 :
 : @param $item a div item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getId($content as element()*){
   fn:string-join(
    for $id in $content[@xml:id]
    return fn:normalize-space($id),
    ' ')
};

(:~
 : NEE project
 : this function creates a map for a div item
 :
 : @param $item a div item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getVolYear($content as element()*){
   fn:string-join(
    for $truc in $content//tei:bibl/tei:date
    return fn:normalize-space($truc),
    ' ')
};


(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getVolbyyeartitle($content as element()*){
      for $yeartitle in fn:distinct-values($content//tei:bibl//tei:date//text())
        return fn:string-join($yeartitle, ' - ')
};

(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getAuthors($content as element()*){
  fn:string-join(
    fn:distinct-values(
      for $name in $content//tei:titleStmt//tei:name//text()
        return fn:string-join($name, ' - ')
      ), 
    ', ')
};





(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getBiblAuthors($content as element()*){
  fn:string-join(
    fn:distinct-values(
      for $name in $content//tei:name//text()
        return fn:string-join($name, ' - ')
      ), 
    ', ')
};

(:~
 : this function get the licence url
 : @param $content texts to process
 : @return the @target url of licence
 :
 : @rmq if a sequence get the first one
 : @todo make it better !
 :)
declare function getCopyright($content){
  ($content//tei:licence/@target)[1]
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getDate($content as element()*){
  fn:normalize-space(
    $content//tei:publicationStmt/tei:date
  )
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblDate($content as element()*){
  fn:normalize-space(
    $content//tei:imprint/tei:date
  )
};



(:~
 : this function get keywords
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of values
 :)
declare function getKeywords($content as element()*){
  fn:string-join(
    for $terms in fn:distinct-values($content//tei:keywords/tei:term) 
    return fn:normalize-space($terms), 
    ', ')
};





(:~
 : this function serialize persName
 : @param $named named content to process
 : @return concatenate forename and surname
 :)
declare function getName($named as element()*){
  fn:normalize-space(
    for $person in $named/tei:persName 
    return ($person/tei:forename || ' ' || $person/tei:surname)
    )
};

(:~
 : this function built a quantity message
 : @param $content texts to process
 : @return concatenate quantity and a message
 : @todo to internationalize
 :)
declare function getQuantity($content as element()*, $unit as xs:string){
  fn:normalize-space(
    if (fn:count($content) > 1) 
      then fn:count($content) || ' ' || $unit || 's disponibles'
      else fn:count($content) || $unit || ' disponible'
    )
};

(:~
 : this function get abstract
 : @param $content texts to process
 : @return a tei abstract
 :)
declare function getFront($content as element()*){
  map {
    'tei' :   $content//tei:front
  }

};


(:~
 : this function get abstract
 : @param $content texts to process
 : @return a tei abstract
 :)
declare function getBody($content as element()*){
 map {
    'tei' :   $content//tei:body
  }
};



(:~
 : this function get abstract
 : @param $content texts to process
 : @return a tei abstract
 :)
declare function getBack($content as element()*){
 map {
    'tei' :   $content//tei:back
  }
};