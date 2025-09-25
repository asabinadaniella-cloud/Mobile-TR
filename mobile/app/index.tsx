import { Link } from 'expo-router';
import { StyleSheet, Text, View } from 'react-native';
import { StatusBar } from 'expo-status-bar';

export default function HomeScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Hello from Expo Router!</Text>
      <Text style={styles.subtitle}>
        This project is bootstrapped with TypeScript and expo-router.
      </Text>
      <Link href="/" style={styles.link}>
        Tap here to reload
      </Link>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
    backgroundColor: '#f2f4f7'
  },
  title: {
    fontSize: 24,
    fontWeight: '600',
    marginBottom: 16,
    color: '#101828',
    textAlign: 'center'
  },
  subtitle: {
    fontSize: 16,
    color: '#475467',
    textAlign: 'center',
    marginBottom: 24
  },
  link: {
    fontSize: 16,
    color: '#7f56d9'
  }
});
