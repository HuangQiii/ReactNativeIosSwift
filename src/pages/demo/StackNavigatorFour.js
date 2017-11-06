import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableHighlight,
    ScrollView,
} from 'react-native';
var Contacts = require('react-native-contacts')

export default class StackNavigatorFour extends Component {

    constructor() {
        super();
        this.state = {
            contactAll: null,
            contacts: null,
        }
    }

    getAllContact() {
        Contacts.getAll((err, contacts) => {
            if (err === 'denied') {
                console.log('error');
            } else {
                console.log(contacts);
                this.setState({
                    contactAll: contacts,
                })
            }
        })
    }

    showSomeOne(filter) {
        Contacts.getContactsMatchingString(filter, (err, contacts) => {
            if (err === 'denied') {
                // x.x
            } else {
                // Contains only contacts matching "filter"
                console.log(contacts);
                this.setState({
                    contacts: contacts,
                })
            }
        })
    }

    renderContact(contact) {
        console.log("renderContact");
        console.log(contact.phoneNumbers[0].number);
        return contact.phoneNumbers[0].number;
    }

    renderContacts(contact) {
        console.log("renderContacts")
        contact.map(i => { this.renderContact(i) })
    }

    render() {
        return (
            <View style={styles.container}>
                <ScrollView style={styles.top}>
                    <Text>Show Number</Text>
                    {this.state.contacts ? this.state.contacts.map(i => <Text key={i.recordID}>{this.renderContact(i)}</Text>) : null}
                </ScrollView>
                <View style={styles.bottom}>
                    <Text style={styles.welcome}>
                        After Contact Install And Link
          </Text>
                    <TouchableHighlight
                        onPress={() => this.getAllContact()}
                    >
                        <Text style={styles.instructions}>
                            Click Me
            </Text>
                    </TouchableHighlight>
                    <TouchableHighlight
                        onPress={() => this.showSomeOne('范')}
                    >
                        <Text style={styles.instructions}>
                            Click Me To Find 云
            </Text>
                    </TouchableHighlight>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        // justifyContent: 'center',
        // alignItems: 'center',
        backgroundColor: '#F5FCFF',
        //flexDirection: 'row'
    },
    top: {
        flex: 1,
        height: 50,
        backgroundColor: '#f2f2f2'
    },
    bottom: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
        //flexDirection: 'row'
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
        backgroundColor: 'gray',
        padding: 20,
    },
});