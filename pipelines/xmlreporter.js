const cucumberJunitConvert = require('cucumber-junit-convert');
 
const options = {
    inputJsonFile: 'test_driver/report/report.json',
    outputXmlFile: 'test_driver/report/report.xml'
 
cucumberJunitConvert.convert(options);
