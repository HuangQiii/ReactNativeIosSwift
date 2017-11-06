import React, { Component } from "react";
import { Text, View, Button } from "react-native";
import { QRScannerView } from 'ac-qrcode';
import { NavigationActions } from 'react-navigation'

export default class ScannerView extends Component {

    render() {
        return (
            < QRScannerView
                onScanResultReceived={this.barcodeReceived.bind(this)}
                renderTopBarView={() => this._renderTitleBar()}
                renderBottomMenuView={() => this._renderMenu()}
            />
        )
    }

    _renderTitleBar() {
        return (
            <Text></Text>
        );
    }

    _renderMenu() {
        return (
            <Text></Text>
        )
    }

    barcodeReceived(e) {
        const { navigate } = this.props.navigation;
        this.props.navigation.dispatch({
            key: 'Open',
            type: 'ReplaceCurrentScreen',
            routeName: 'Open',
            params: { url: e.data },
        });
    }
}