import React, {
    Component,
} from 'react';
import {
    Container,
    Header,
    Content,
    List,
    ListItem,
    Text,
    Icon,
    Left,
    Body,
    Right,
    Switch,
    Thumbnail
} from 'native-base';
import {
    TouchableHighlight,
    View,
} from 'react-native';
import { NativeModules } from 'react-native';

export default class ListIconExample extends Component {

    static propTypes = {
        nav: React.PropTypes.object,
    };

    constructor(props) {
        super(props);

        this.state = {
            messageNotification: false,
        };
    }

    render() {
        const { navigate } = this.props.nav;
        return (
            <Container>
                <Content style={{ backgroundColor: '#F1F1F1', }}>
                    <List style={{ backgroundColor: '#FFFFFF', borderTopWidth: 0.5, borderTopColor: '#D1D1D1' }}>
                        <ListItem avatar last>
                            <Left>
                                <Thumbnail source={{ uri: 'https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2345970869,892410183&fm=173&s=8400FD17199351ED598CA8F503008063&w=218&h=146&img.JPEG' }} />
                            </Left>
                            <Body>
                                <Text>Huang Qi</Text>
                                <Text note>Doing what you like will always keep you happy . .</Text>
                            </Body>
                            <Right style={{ justifyContent: 'center', }}>
                                <TouchableHighlight
                                    onPress={() => navigate('Head')}
                                >
                                    <Icon name="arrow-forward" />
                                </TouchableHighlight>
                            </Right>
                        </ListItem>

                        <Content style={{ flex: 1, backgroundColor: '#eeeeee', height: 20 }}></Content>
                        <ListItem icon first>
                            <Left><Icon name="plane" style={{ color: 'lightskyblue' }} /></Left>
                            <Body><Text style={{ fontSize: 16 }}>消息通知</Text></Body>
                            <Right><Switch
                                value={this.state.messageNotification}
                                onValueChange={(value) => {
                                    this.setState({ messageNotification: value })
                                }}
                                onTintColor={'lightskyblue'}
                                thumbTintColor={'#039BE5'}
                            />
                            </Right>
                        </ListItem>
                        <ListItem icon>
                            <Left><Icon name="wifi" style={{ color: '#fab614' }} /></Left>
                            <Body><Text style={{ fontSize: 16 }}>个人信息修改</Text></Body>
                            <Right><Icon name="arrow-forward" /></Right>
                        </ListItem>
                        <ListItem icon last>
                            <Left><Icon name="bluetooth" style={{ color: '#F28B8B' }} /></Left>
                            <Body><Text style={{ fontSize: 16 }}>账号绑定</Text></Body>
                            <Right><Text style={{ fontSize: 12 }}>已绑定</Text><Icon name="arrow-forward" /></Right>
                        </ListItem>

                        {/*<Content style={{ flex: 1, backgroundColor: '#eeeeee', height: 20 }}></Content>
                        <ListItem icon first>
                            <Left><Icon name="plane" style={{ color: 'lightskyblue' }} /></Left>
                            <Body><Text style={{ fontSize: 16 }}>我是占位的</Text></Body>
                            <Right><Icon name="arrow-forward" /></Right>
                        </ListItem>
                        <ListItem icon>
                            <Left><Icon name="wifi" style={{ color: '#fab614' }} /></Left>
                            <Body><Text style={{ fontSize: 16 }}>我是占位的</Text></Body>
                            <Right><Icon name="arrow-forward" /></Right>
                        </ListItem>
                        <ListItem icon last>
                            <Left><Icon name="bluetooth" style={{ color: '#F28B8B' }} /></Left>
                            <Body><Text style={{ fontSize: 16 }}>我是占位的</Text></Body>
                            <Right><Icon name="arrow-forward" /></Right>
                        </ListItem>*/}

                        <Content style={{ flex: 1, backgroundColor: '#eeeeee', height: 20 }}></Content>
                        <ListItem icon first last>
                            <Left><Icon name="bluetooth" /></Left>
                            <Body><Text style={{ fontSize: 16 }}>版本说明</Text></Body>
                            <Right><Text style={{ fontSize: 12 }}>1.0.0-alpha.beta</Text><Icon name="arrow-forward" /></Right>
                        </ListItem>

                        <Content style={{ flex: 1, backgroundColor: '#eeeeee', height: 20 }}></Content>
                        <TouchableHighlight
                            onPress={() => {
                                NativeModules.NativeManager.setToken('');
                                this.props.nav.dispatch({
                                    key: 'Login',
                                    type: 'ReplaceCurrentScreen',
                                    routeName: 'Login',
                                });
                            }}
                        >
                            <View style={{ flex: 1, backgroundColor: '#FFFFFF', height: 40, justifyContent: 'center', alignItems: 'center', }}>
                                <Text>退出</Text>
                            </View>
                        </TouchableHighlight>
                    </List>
                </Content>
            </Container >
        );
    }
}