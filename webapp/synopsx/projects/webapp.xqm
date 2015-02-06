xquery version "3.0" ;
module namespace synopsx.webapp = 'synopsx.webapp';
(:~
 : This module is the RESTXQ for SynopsX
 : @version 0.2 (Constantia edition)
 : @date 2014-11-10 
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
 : with SynopsX. If not, see <http://www.gnu.org/licenses/>
 :
 :)

import module namespace G = "synopsx.globals" at '../globals.xqm';

(: Put here all import modules declarations as needed :)
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm';

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm';

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm';

(: Use a default namespace :)
declare default function namespace 'synopsx.webapp';

(:~
 : ~:~:~:~:~:~:~:~:~
 : To be use to implement the webapp entry points
 : Used in the last version of synopsx  
 : ~:~:~:~:~:~:~:~:~
 : These five functions analyze the given path and retrieve the data
 :
 :)

(:~
 : this resource function redirect to /home
 :)
declare 
  %restxq:path("")
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/home"/>
    </http:response>
  </rest:response>
};


(:~
 : this resource function 
 : @return a home based on the default project
 : @todo move project test to lib/ ?
 :)
declare 
  %restxq:path("/home")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function home() {
  let $project := 
    if(file:exists($G:CONFIGFILE)) then
      if(fn:doc($G:CONFIGFILE)//project[@default="true"]/resourceName/text()) then 
        fn:doc($G:CONFIGFILE)//project[@default="true"]/resourceName/text()
      else fn:doc($G:CONFIGFILE)//project[1]/resourceName/text()
    else ()
  return if(fn:empty($project)) then
    <rest:response>
      <http:response status="303" message="See Other">
        <http:header name="location" value="/synopsx/install"/>
      </http:response>
    </rest:response>
  else 
  let $model := 'synopsx.models.tei'
  let $queryParams := map {
    'project' : $project,
    'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
    'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
    'dataType' : 'getCorpusList'
  }
  let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
  let $data := synopsx.models.tei:getCorpusList($queryParams)
  let $layout  := 'home.xhtml'
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, '') (: give $data instead of $queryParams:)
};

(:~
 : this resource function 
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('{$project}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project) {
    let $project := $project
    let $model := 'todo'
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'todo', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'todo'
    }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    let $data := todo (: synopsx.models.tei:getCorpusList($queryParams) :)
    let $layout  := 'todo.xhtml'
    return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
    synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, '') (: give $data instead of $queryParams:)
};

(:~
 : this resource function 
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('{$project}/{$dataType}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project, $dataType) {
    let $project := $project
    let $model := 'todo'
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'todo', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'todo'
    }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    let $data := todo (: synopsx.models.tei:getCorpusList($queryParams) :)
    let $layout  := 'todo.xhtml'
    return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
    synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, '') (: give $data instead of $queryParams:)
};

(:~
 : this resource function 
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('{$project}/{$dataType}/{$value}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project, $dataType, $value) {
    let $project := $project
    let $model := 'todo'
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'todo', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'todo'
    }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    let $data := todo (: synopsx.models.tei:getCorpusList($queryParams) :)
    let $layout  := 'todo.xhtml'
    return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
    synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, '') (: give $data instead of $queryParams:)
};

(:~
 : this resource function 
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('{$project}/{$dataType}/{$value}/{$options}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project, $dataType, $value, $options) {
    let $project := $project
    let $model := 'todo'
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'todo', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'todo'
    }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    let $data := todo (: synopsx.models.tei:getCorpusList($queryParams) :)
    let $layout  := 'todo.xhtml'
    return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
    synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, '') (: give $data instead of $queryParams:)
};
