xquery version "3.0" ;
module namespace cachette.webapp = 'cachette.webapp' ;

(:~
 : This module is the RESTXQ for SynopsX's example
 :
 : @version 2.0 (Constantia edition)
 : @since 2015-02-05 
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

(: Import synopsx's globals variables and libraries :)
import module namespace G = "synopsx.globals" at '../../../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;

(: Put here all import modules declarations as needed :)
import module namespace cachette.models.tei = 'cachette.models.tei' at '../models/tei.xqm' ;

(: import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../../../models/tei.xqm' ; :)

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;

(: Use a default namespace :)
declare default function namespace 'cachette.webapp' ;


declare variable $cachette.webapp:project := 'cachette' ;
declare variable $cachette.webapp:db := synopsx.lib.commons:getProjectDB($cachette.webapp:project) ;



(:~
 : this resource function redirect to /home
 :
 :)
declare 
  %restxq:path("/cachette")
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/cachette/home"/>
    </http:response>
  </rest:response>
};

(:~
 : Page d'accueil
 :)
declare 
  %restxq:path('/cachette/home')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function home() {
  let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getTextsList'
    }
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_thumbnail_home.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }  
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};


(:~
 : #EM créé avec carole
 :)
declare 
  %restxq:path('/cachette/inscriptions/{$id}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function TextById($id as xs:string?) {  
    let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getTextById',
    'id' : $id
    }
   let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'objet.xhtml',
    'pattern' : 'inc_tab_text.xhtml',
    'xquery' : 'true'
    (: specify an xslt mode and other kind of output options :)
    }
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};



(: ------------------------------------------ :)
(: ------------- en test   ------------------ :)


(:~
 : this resource function is the html representation of the corpus resource
 :
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare
  %restxq:path('/cachette/html/{$id}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function textHtml($id) { 
    let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getTextById',
    'id' : $id
    }
   let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'objet.xhtml',
    'pattern' : 'inc_tab_text.xhtml',
    'xsl' : 'toto.xsl' 
    }
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};



(:~
 : #EM test rsbytype
 :)
declare 
  %restxq:path('/cachette/rs/{$type}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function getRsByType($type as xs:string?) {  
    let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getRsByType',
    'type' : $type
    }
   let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_defaultItem.xhtml',
    'xquery' : 'true'
    (: specify an xslt mode and other kind of output options :)
    }
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};



(: ------------------------------------------------------- :)
(: -----------------à supprimer    ----------------------- :)
(: ------------------------------------------------------- :)
(:~
 : this resource function is the corpus resource
 :
 : @return an HTTP message with Content-location against the user-agent request
 : @rmq Content-location in HTTP can be used when a requested resource has 
 : multiple representations. The selection of the resource returned will depend 
 : on the Accept headers in the original GET request.
 : @bug not working curl -I -H "Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" http://localhost:8984/corpus/
 :)
declare 
  %restxq:path('/cachette/texts')
  %rest:produces('application/json')
  %output:method('json')
function textsJS() {
   let $queryParams := map {
      'project' : $cachette.webapp:project,     
      'dbName' : $cachette.webapp:db,
      'model' : 'tei',
      'function' : 'getTextsList'
    }    
   let $function := xs:QName(synopsx.lib.commons:getModelFunction($queryParams))
    return fn:function-lookup($function, 1)($queryParams)
};

(:~
 : this resource function is the html representation of the corpus resource
 :
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/cachette/texts')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function textsHtml() {  
    let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getTextsList'
    }
   let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};

declare 
  %restxq:path('/cachette/resp')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function respHtml() {
    let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getRespList'
    }
    
     let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_respItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
    
    
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};

declare 
  %restxq:path('/cachette/bibl')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblHtml() {
    let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getBiblList'
    }
    
    let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_BiblItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
    
      
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};







(:~
 : this resource function is a corpus list for testing
 :
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @return an html representation of the corpus list
 : @todo use this tag !
 :)
declare 
  %restxq:path("/cachette/inc/texts")
 (:  %restxq:query-param("pattern", "{$pattern}") :)
function corpusListHtml() {
    let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getTextsList'
    }
    
   let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'inc_defaultList.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
   return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};

(:~
 : this resource function is a bibliographical list for testing
 :
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @return an html representation of the bibliographical list
 : @todo use this tag !
 :)
declare 
  %restxq:path("/cachette/inc/resp")
  %restxq:query-param("pattern", "{$pattern}")
function biblioListHtml($pattern as xs:string?) {
  let $queryParams := map {
    'project' : $cachette.webapp:project,
    'dbName' :  $cachette.webapp:db,
    'model' : 'tei' ,
    'function' : 'getRespList'
    }

  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'inc_defaultList.xhtml',
    'pattern' : 'inc_RespItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
        
return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};  