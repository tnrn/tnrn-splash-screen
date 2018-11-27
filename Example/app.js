/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react'

import {
  StyleSheet,
  Text,
  View
} from 'react-native'

import RNKitSplashScreenManager from 'tnrn-splash-screen'

export default class App extends Component {
  hiddenSplashScreen () {
    RNKitSplashScreenManager.close()
  }

  componentDidMount () {
    this.progress = 0

    const timer = setInterval(() => {
      this.progress = this.progress + 0.1
      if (this.progress > 0.3) {
        RNKitSplashScreenManager.tipText('开始哈哈哈哈哈哈')
      }
      if (this.progress > 0.5) {
        RNKitSplashScreenManager.tipText('00000000000000')
      }
      if (this.progress > 0.8) {
        RNKitSplashScreenManager.tipText('12312312312312')
      }
      RNKitSplashScreenManager.progress(this.progress)

      if (this.progress > 1) {
        console.log('------------------------------------')
        console.log(this.progress)
        console.log('------------------------------------')
        clearInterval(timer)
        RNKitSplashScreenManager.close({animationType: RNKitSplashScreenManager.animationType.scale, duration: 850, delay: 500})
        setTimeout(() => {
          console.log('-------------- |||||||||||| ---------------------')
          RNKitSplashScreenManager.open()
        }, 2000)
      }
    }, 1000)
  }

  render () {
    return (
      <View style={styles.container}>

      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexWrap: 'wrap',
    backgroundColor: '#F5FCFF'
  }
})
