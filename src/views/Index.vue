<template>
  <BaseView class="container">
    <template v-slot:main-content>
      <div>
        <h3 class="title">Welcome to Tasmia</h3>
        <button type="button" class="btn btn-lg btn-outline-danger upload" id="upload" @click="upload">Upload Data</button>
        <input type="file" id="upload-file" ref="fileInput" class="fileCheck" @change="fileCheck">
        <a id="sampleCSV" href="/static/files/sample_trainset.csv" download>sample CSV</a>
      </div>
      <br>
      <div class="info">
        <h5 class="subh">What is it?</h5>
        Tasmia is a graphical tool for labeling time series data. Labeling is typically used to record interesting points in time series data. For example, if you had temperature data from a sensor mounted to a stove, you could label points  that constitute cooking events. Labels could be used as-is or as a training set for machine learning algorithms. For example, Tasmia could be used to build a training set for an algorithm that detects cooking events in temperature time series data.<br>
        <img src="static/files/trainset.gif" alt="TRAINSET time series brushing and labeling animation" style="width:600px;height:391px;"><br><br>
        
        <h5 class="subh">Where did it come from?</h5>
        Tasmia was built for the  <a href="https://fevm.ethglobal.com/" target="_blank">hackfevm</a>. orgnized by ethglobal, the idea for it be a part of a data labeling dao. its a promising project.   
      </div>
    </template>
  </BaseView>
</template>

<script>
const { DateTime } = require("luxon");
const strftime = require('strftime');
// const Web3Storage  = require('web3.storage');

export default {
  name: 'index',
  data: function() {
    return {
      errorUpload: false
    }
  },
  props: {
    nextUp: Boolean
  },
  methods: {
    // push Labeler.vue invalid landing
    error() {
      this.errorUpload = true;
      this.$router.push({
        name: 'labeler',
        params: {
          csvData: [],
          minMax: [],
          filename: "",
          headerStr: "",
          isValid: false
        }
      });
    },
    // trigger file upload
    shouldUpload() {
      if (this.nextUp === true) {
        setTimeout(() => this.upload(), 100);
      }
    },
    upload () {
      this.$refs.fileInput.click();
    },
    // check format validity of csv
    fileCheck () {
      window.onerror = (errorMsg, url, lineNumber) => {
        this.error();
      }
      // var client  = new Web3Storage('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEI3NTI4ZjQ3OUYyMzI1NjYxNjA5ZEQ3MGFkNzkwYWMyNjc5MDlDMmYiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2Njg5MzkwOTk0NDUsIm5hbWUiOiJ0YXNtZWEifQ.xDXK74xPdt1OxE1NjQlLN0OLl9_VV5WI7BPTeuttwEc');
      var fileInput = document.getElementById("upload-file").files.item(0), fileText;
      // const rootCid = client.put(fileInput.files);
      var filename = fileInput.name.split('.csv')[0];
      var id = 0;
      var reader = new FileReader();
      var seriesList = new Set(), labelList = new Set(), plotDict = [], headerStr;
      reader.readAsBinaryString(fileInput);
      reader.onloadend = () => {
        fileText = $.csv.toArrays(reader.result);
        headerStr = fileText[0].toString();
        for (var i = 1; i < fileText.length ; i++) {
          var dateMatches = fileText[i][1].match(/^((\d{4})-(\d{2})-(\d{2})T(\d{2})\:(\d{2})\:(\d{2})(.(\d{3}))?(([+-](\d{2})\:?(\d{2}))|Z))$/)
          var labelMatches = fileText[i][3].match(/^[a-zA-Z0-9_-]{0,16}$/)
          var parsedValue = Number(fileText[i][2]).toString()
          if (fileText[i].length === 4 
            && dateMatches
            && labelMatches
            && parsedValue !== Number.NaN) {
            var date = DateTime.fromISO(fileText[i][1], {setZone: true});
            var series = fileText[i][0];
            seriesList.add(series);
            if (fileText[i][3]) {
              labelList.add(fileText[i][3]);
            }
            plotDict.push({
              'id': id.toString(),
              'val': parsedValue,
              'time': date,
              'series': series,
              'label': fileText[i][3]
            });
            id++;
          } else {
            if (!(fileText[i].length === 4)) {
              console.log('line parse error in line ' + (i+1));
            } else if (!labelMatches) {
              console.log('label parse error in line ' + (i+1));
            } else if (parsedValue === Number.NaN) {
              console.log('value parse error in line ' + (i+1));
            } else {
              console.log('date parse error in line ' + (i+1));
            }
            this.error();
            break;
          }
        }
        // if there was no error parsing csv
        if (!this.errorUpload) {
          seriesList = Array.from(seriesList);
          labelList = Array.from(labelList);

          this.$router.push({
            name: 'labeler',
            params: {
              csvData: plotDict,
              filename: filename,
              headerStr: headerStr,
              seriesList: seriesList,
              labelList: labelList,
              isValid: true
            }
          });
        }
      }
    }
  },
  created() {
    this.shouldUpload();
  }
};
</script>

<style scoped>
#upload { margin-top: 20px; border-width: 3px; border-color: #2551c2; color: #2551c2; padding: 15px 60px; }
#upload:hover {  background: #2551c2; color: #f4f4f4; }
#upload-file { display: none; }
.subh { font-weight: 900 !important; }
#sampleCSV {
  display: block;
  padding-top: 10px;
  padding-bottom: 5px;
  margin-left: 40%;
  margin-right: 40%;
}
</style>