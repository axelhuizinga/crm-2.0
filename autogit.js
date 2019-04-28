var fs = require("fs"),
    path = require("path"),
    util = require("util");
var cMessage = fs.readFileSync("cmessage.txt", 'utf8');
var eSync = require('child_process').execSync;
var gPath = eSync('npm config get prefix', {stdio:[1]}).toString().replace(/\n|\r/, '') + '/node_modules/';
console.log(cMessage);
//console.log(gPath + '<');
var log = require(gPath + 'tracer').console(
    {
        format : "{{timestamp}} <{{title}}> {{message}} (in {{file}}:{{line}})",
        dateformat : "HH:MM:ss"
    });
var Git = require(gPath + "nodegit");
var aRepo, index;
var getMostRecentCommit = function(repository) {
    aRepo = repository;
    log.log(aRepo.toString());
    return repository.getBranchCommit("master");
  };
  
var getCommitMessage = function(commit) {
return commit.message();
};
main().catch(log.error);
async function main()
{
    aRepo = await Git.Repository.open('.');
    index = await aRepo.index();
    var added = await index.addAll(['.']);
    log.log(added);
    var written = await index.write();
    log.log(written);
    var tree = await  index.writeTree();
    log.log(tree);
    
    
}
/*
@echo off
SetLocal EnableDelayedExpansion
set CMessage=
for /F "delims=" %%i in (cmessage.txt) do set CMessage=!CMessage! %%i

echo %CMessage%
EndLocal
set /p  Version=<version
set /p  Build_ID=<build

echo %CMessage% > clast.txt
echo %Build_ID%
set /A  Build_ID=Build_ID+1
echo %Build_ID% >build
echo %Version%.%Build_ID%

git add -A
git commit -am "AutoCommit Build: %Version%+%Build_ID% %CMessage%"
git push
break>cmessage.txt
*/
