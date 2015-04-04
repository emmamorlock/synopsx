xquery version '3.0' ;
module namespace cachette.models.tei = 'cachette.models.tei' ;

(:~
 : This module is for TEI models
 :
 : @version 1.0 (Cachette de Karnak project)
 : @since 2015-03-31 
 : @author Emmanuelle Morlock
 :
 : File copied form the SynopsX framework
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 :)

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../../../models/tei.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace "cachette.models.tei";


(:~
 : fonction d'origine de synopsx
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getTextsList($queryParams as map(*)) as map(*) {
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:TEI
  let $meta := map{
    'title' : 'Liste des textes'
    }
  let $content := for $text in $texts return getHeaderText($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};


(:~
 : fonction em
 : 
 :)
declare function getTextById($queryParams as map(*)) as map(*) {
  let $text := synopsx.lib.commons:getDb($queryParams)//tei:TEI[@xml:id=map:get($queryParams, 'id')]
  let $meta := map{
    'title' : getTitles($text),
    'author' : getAuthors($text)
    }
  let $content :=  getText($text)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};


(:~
 : 
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
    'tei' : $item/tei:text/tei:body/tei:div[@type='edition']
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getHeaderText($item as element()) {
   map {
    'title' : getTitles($item/tei:teiHeader),
    'date' : getDatation($item/tei:teiHeader),
    'author' : getAuthors($item/tei:teiHeader),
    'url' : getUrl($item),
    'tei' : getBiblReference($item/tei:teiHeader),
    'url_img' : getUrlImg($item/tei:facsimile)
  }
};



declare function getBiblReference($content as element()*){
   fn:string-join(
    for $bibl in $content//tei:sourceDesc/tei:bibl
    return fn:normalize-space($bibl),
    ' ')
};

declare function getDatation($content as element()*){
   fn:string-join(
    for $datation in $content//tei:history//tei:origDate/text()
    return fn:normalize-space($datation),
    ', ')
};

declare function getUrl($content as element()*){
  fn:concat('/cachette/inscriptions/',
    for $url in $content/@xml:id
    return fn:normalize-space($url))
};

declare function getUrlImg($content as element()*){
    for $urlImg in $content/tei:graphic[@n='1']/@url
    return fn:replace($urlImg,"http://www.ifao.egnet.net/bases/cachette/docs/vues/", "/synopsx/files/img/img2/")
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
    for $title in $content/tei:fileDesc/tei:titleStmt/tei:title/text()
    return fn:string-join($title), ' ')
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
(: ------------ a supprimer :)
(:~
 : fonction créée le 2015-03-31 - copiée de skepsis - ASSUPRIMER
 : this function returns a sequence of map for meta and content
 : !! the result structure has changed to allow sorting early in mapping
 :
 : @rmq for testing with new htmlWrapping
 :)
declare function getTextsList_skepsis($queryParams as map(*)) as map(*) {
  let $meta := map{
    'title' : 'Liste des textes'
    }
  let $content := for $volumen in synopsx.lib.commons:getDb($queryParams)/tei:TEI[fn:not(@xml:id = "skepsis")]
                     let $premierLivre := $volumen//tei:div[@type="livre"][1]
                     let $premierChapitre := $premierLivre//tei:div[@type="chapitre"][1]
                     return 
                     map {
                          'url': "volumen/" || $volumen//tei:titleStmt/tei:title/text() || "/livre/" || fn:data($premierLivre/@n) || "/chapitre/" || fn:data($premierChapitre/@n),
                          'author':$volumen//tei:titleStmt/tei:author/text(),
                          'title':$volumen//tei:titleStmt/tei:title/text() 
                         } 
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};
