const cucumberJunitConvert = require('cucumber-junit-convert');
var path = require('path');
var jsonPath = path.join(__dirname, '..', 'test_driver', 'reports');
 
const options = {
    inputJsonFile: jsonPath + '/report.json',
    outputXmlFile: jsonPath + '/report.xml'
}
 
cucumberJunitConvert.convert(options);
