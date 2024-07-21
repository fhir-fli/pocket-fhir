import 'dart:io';

import 'package:fhir_r5/fhir_r5.dart';
import 'package:pocketbase/pocketbase.dart';

class HttpOverridesImpl extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = HttpOverridesImpl();

  final PocketBase pb = PocketBase('https://localhost');

  // Authenticate
  await pb.admins.authWithPassword('grey@fhirfli.dev', '01 password');

  await assets(pb);
}

Future<void> assets(PocketBase pb) async {
  final Directory dir1 = Directory('assets');
  final List<FileSystemEntity> files = dir1.listSync();
  for (final FileSystemEntity file in files) {
    if (file is File) {
      print(file.path);
      if (file.path.endsWith('.json')) {
        final Bundle bundle = Bundle.fromJsonString(file.readAsStringSync());
        for (final BundleEntry entry in bundle.entry ?? <BundleEntry>[]) {
          final resource = entry.resource;
          if (resource != null) {
            await createOrUpdateRecord(pb, resource.toJson());
          }
        }
      } else if (file.path.endsWith('.ndjson')) {
        final List<String> lines = file.readAsLinesSync();
        for (final String line in lines) {
          final Resource resource = Resource.fromJsonString(line);
          await createOrUpdateRecord(pb, resource.toJson());
        }
      }
    }
  }
}

Future<void> examples(PocketBase pb) async {
  final Directory dir2 = Directory('examples');
  final List<FileSystemEntity> files2 = dir2.listSync();
  for (final FileSystemEntity file in files2) {
    if (file is File) {
      print(file.path);
      final Resource resource =
          Resource.fromJsonString(await file.readAsString());
      await createOrUpdateRecord(pb, resource.toJson());
    }
  }
}

// Function to create or update a record
Future<void> createOrUpdateRecord(
    PocketBase pb, Map<String, dynamic> resource) async {
  try {
    await pb
        .collection(resource['resourceType'].toString().toLowerCase())
        .create(body: createBody(resource));
  } catch (e) {
    print(e);
  }
}

Map<String, dynamic> createBody(Map<String, dynamic> resource) => {
      "resourceType": resource['resourceType'],
      "versionId": 1,
      "resource": resource,
    };
