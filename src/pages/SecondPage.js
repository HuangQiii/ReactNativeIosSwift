'use strict';
import React, {
    Component,
} from 'react';
import { NativeModules } from 'react-native';
import {
    Image,
    ListView,
    StyleSheet,
    Text,
    View,
    Alert,
    TouchableWithoutFeedback,
    RefreshControl,
    Dimensions,
    ToastAndroid,
    ScrollView,
} from 'react-native';
import Swiper from 'react-native-swiper';

let iconPath = '';//模块图标路径
var REQUEST_URL = '';
let token = '';
const { width, height } = Dimensions.get('window');
export default class SecondPage extends Component {

    static propTypes = {
        nav: React.PropTypes.object,
    };

    constructor(props) {
        super(props);

        this.state = {
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            swiperShow: false,
            loaded: false,
            isRefreshing: false,
        };
        this.fetchData = this.fetchData.bind(this);
        this.refresh = this.refresh.bind(this);
    }

    componentDidMount() {
        this.refresh();
        setTimeout(() => {
            this.setState({ swiperShow: true });
        }, 0)
        console.log("hello")
    }

    componentWillUnmount() {
        this.timer && clearTimeout(this.timer);
    }

    async refresh() {
        this.setState({
            isRefreshing: false
        });
        // NativeModules.NativeManager.getConfigData()
        //     .then((back) => {
        //         REQUEST_URL = back['serverUrl'] + "/getData/1";
        //         console.log(REQUEST_URL);
        //         iconPath = back['appPath'] + '/icon';
        //         console.log(iconPath);
        //         token = back['token'];
        //         console.log(token);
        //     })
        //     .then(() => {
        //         this._fetch(REQUEST_URL, 10000)
        //             .then((info) => {
        //                 console.log("yes");
                        this.loadRemoteData();
        //                 this.setState({
        //                     isRefreshing: false
        //                 });
        //             }).catch((err) => {
        //                 console.log("error");
        //                 this.loadLoaclData();
        //                 // throw new Error(err);
        //                 this.setState({
        //                     isRefreshing: false
        //                 });
        //             });
        //     });
        var nativeManager = NativeModules.NativeManager;
        try {
            const back = await nativeManager.getConfigData();
            REQUEST_URL = back[0] + "/getData/3";
            token = back[1];
            iconPath = back[2] + '/icon';
            this._fetch(REQUEST_URL, 10000)
                    .then((info) => {
                        console.log("yes");
                     this.loadRemoteData();
                        this.setState({
                            isRefreshing: false
                        });
                    }).catch((err) => {
                        console.log("error");
                        this.loadLoaclData();
                        throw new Error(err);
                        this.setState({
                            isRefreshing: false
                        });
                    });
        } catch (e) {
            console.error(e);
        }
    }

    // 超时版的fetch
    _fetch(url, timeout) {
        return Promise.race([
            fetch(url, {
                headers: {
                    "Authorization": token
                }
            }),
            new Promise(function (resolve, reject) {
                setTimeout(() => reject(new Error('request timeout')), timeout);
            })
        ]);
    }

    /**
     * 
     *  加载本地模块
     * 
     * @memberof ThirdPage
     */
    loadLoaclData() {
        // NativeModules.NativeManager.getLocalData()
        //     .then((back) => {
        //         var bundleData = back.split('{');
        //         var DATA = [];
        //         for (var i = 1; i < bundleData.length; i++) {
        //             var info = bundleData[i].split(',');
        //             var id = info[0].split(':')[1];
        //             var name = info[1].split(':')[1];
        //             var data = {
        //                 id,
        //                 name
        //             }
        //             DATA.push(data);
        //         }
        //         this.setState({
        //             dataSource: this.state.dataSource.cloneWithRows(DATA),
        //             loaded: true,
        //         });
        //     });
    }

    /**
     * 加载远程模块并验证
     * 
     * @memberof ThirdPage
     */
    loadRemoteData() {
        console.log("downloadIcon")
        NativeModules.NativeManager.downloadIcon((back) => {
            // console.log(back);
            if (back != null && back != "") {
                iconPath = back;
            }
        });
        this.fetchData();
        this.timer = setTimeout(() => {
            this.mainUpdate();
        },
            2000
        );
    }

    fetchData() {
        console.log("i am in ")
        fetch(REQUEST_URL, {
            headers: {
                "Authorization":token
            }
        })
            .then((response) => response.json())
            .then((responseData) => {
                if (responseData.error == undefined) {
                    this.setState({
                        dataSource: this.state.dataSource.cloneWithRows(responseData),
                        loaded: true,
                    });
                } else {
                    this.setState({
                        dataSource: this.state.dataSource.cloneWithRows([]),
                        loaded: true,
                    });
                }
                console.log("*********");
                console.log(responseData);
            });
    }

    mainUpdate() {
        // NativeModules.NativeManager.checkMainUpdateAble((back) => {
        //     if (back == "netError") {
        //         Alert.alert("网络或服务器出错，请重启软件再尝试！");
        //     } else if (back != null) {
        //         Alert.alert(
        //             "是否更新主模块？",
        //             back,
        //             [
        //                 {
        //                     text: '是',
        //                     onPress: () => {
        //                         NativeModules.NativeManager.updateMain((type, result) => {
        //                             if (type == "success") {
        //                                 //ToastAndroid.show(result, ToastAndroid.SHORT);
        //                             } else {
        //                                 ToastAndroid.show(result, ToastAndroid.SHORT);
        //                             }
        //                         });
        //                     }
        //                 },
        //                 {
        //                     text: '否'
        //                 }
        //             ]
        //         );
        //     }
        // });
    }

    renderSwiper = () => {
        if (this.state.swiperShow) {
            return (
                <Swiper style={styles.wrapper} height={150}
                    dot={<View style={{ backgroundColor: 'rgba(0,0,0,.2)', width: 5, height: 5, borderRadius: 4, marginLeft: 3, marginRight: 3, marginTop: 3, marginBottom: 3 }} />}
                    activeDot={<View style={{ backgroundColor: '#FFFFFF', width: 8, height: 8, borderRadius: 4, marginLeft: 3, marginRight: 3, marginTop: 3, marginBottom: 3 }} />}
                    paginationStyle={{
                        bottom: 10, right: 10, left: null,
                    }}
                    loop={true}
                    autoplay={false}
                    horizontal={true}
                    index={0}
                    autoplayTimeout={5}>
                    <View style={styles.slide} title={<Text numberOfLines={1}></Text>}>
                        <Image resizeMode='stretch' style={styles.image} source={{ uri: 'https://wuguokai.github.io/img/bg1.jpg' }} />
                    </View>
                    <View style={styles.slide} title={<Text numberOfLines={1}></Text>}>
                        <Image resizeMode='stretch' style={styles.image} source={{ uri: 'https://wuguokai.github.io/img/bg2.jpg' }} />
                    </View>
                    <View style={styles.slide} title={<Text numberOfLines={1}></Text>}>
                        <Image resizeMode='stretch' style={styles.image} source={{ uri: 'https://wuguokai.github.io/img/bg3.jpg' }} />
                    </View>
                </Swiper>
            );
        } else {
            return <View style={{ height: 150, }}></View>;
        }
    }

    render() {
        if (!this.state.loaded) {
            return this.renderLoadingView();
        }
        const { navigate } = this.props.nav;
        return (
            <View style={{ backgroundColor: '#F1F1F1', height: height }}>
                <ScrollView
                    refreshControl={
                        <RefreshControl
                            refreshing={this.state.isRefreshing}
                            onRefresh={this.refresh.bind(this)}
                            tintColor="grey"
                            title="Loading..."
                            titleColor="grey"
                            colors={['#eeeeee', '#dddddd', '#ffffff']}
                            progressBackgroundColor="grey"
                        />
                    }
                >
                    <View style={{ height: 150, backgroundColor: '#FFFFFF' }}>
                        {this.renderSwiper()}
                    </View>

                    <View style={[styles.listTitleBlock, { flexDirection: 'row' }]}>
                        <Text style={styles.listTitle}>可用模块</Text>
                    </View>
                    <ListView
                        style={{ backgroundColor: '#FFFFFF', borderTopWidth: 1, borderTopColor: '#EEEEEE' }}
                        dataSource={this.state.dataSource}
                        renderRow={this.renderIcon.bind(this)}
                        contentContainerStyle={styles.listView}
                    />
                </ScrollView>
            </View>
        );
    }

    renderLoadingView() {
        return (
            <View style={styles.containerLoading}>
                <Text>
                    Loading...
                </Text>
            </View>
        );
    }

    _onIconClick(name, id, bundleVersionId) {
        this.show(name, id, bundleVersionId);
    }

    show(name, id) {
        NativeModules.NativeManager.openBundle(name, (type) => {
            let title = ""
            if (type == "netError") {
                Alert.alert("网络或服务器出错，请重启软件再尝试！");
            }else{
            if (type == "update") {
                title = "发现新版本,是否升级?"
            } else {
                title = "未安装应用，是否安装？"
            }
            Alert.alert(
                title,
                title,
                [
                    {
                        text: '是',
                        onPress: () => {
                            NativeModules.NativeManager.downloadAndOpenBundle(name, id, (type) => {
                                console.log("+++")
                                console.log(id)
                                if (type == "netError") {
                                    Alert.alert("网络或服务器出错，请重启软件再尝试！");
                                } else if (type == "success") {
                                    Alert.alert("success");
                                } else {
                                    Alert.alert("failed");
                                }
                            });
                        }
                    },
                    {
                        text: '否'
                    }
                ]
            );
            }
        });
    }

    renderIcon(icon) {
        // console.log(iconPath)
        const iconUri = "file://"+iconPath +'/'+ icon.name + '.png';
        // console.log("========="+iconUri);
        return (
            <TouchableWithoutFeedback onPress={() => this._onIconClick(icon.name, icon.id)}>
                <View style={styles.container}>
                    <Image
                        source={{uri: iconUri}}
                        style={styles.thumbnail}
                    />
                    <View>
                        <Text style={styles.name}>{icon.name}</Text>
                    </View>
                </View>
            </TouchableWithoutFeedback>
        );
    }
}

var styles = StyleSheet.create({
    containerLoading: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    container: {
        width: width / 4,
        height: 100,
        paddingTop: 20,
        alignItems: 'center',
        borderRightWidth: 1,
        borderBottomWidth: 1,
        borderColor: '#EEEEEE',
    },
    listTitleBlock: {
        backgroundColor: '#FFFFFF',
        borderLeftWidth: 5,
        borderLeftColor: '#0092DA',
        marginTop: 15,
    },
    listTitle: {
        textAlign: 'left',
        fontSize: 14,
        margin: 10,
    },
    name: {
        textAlign: 'center',
        fontSize: 10,
        marginTop: 10,
    },
    thumbnail: {
        width: 40,
        height: 40,
        borderRadius: 5,
    },
    listView: {
        justifyContent: 'flex-start',
        flexDirection: 'row',
        flexWrap: 'wrap'
    },

    slide: {
        flex: 1,
        justifyContent: 'center',
        backgroundColor: 'transparent'
    },
    text: {
        color: '#fff',
        fontSize: 30,
        fontWeight: 'bold'
    },
    image: {
        width: width,
        flex: 1
    }
});