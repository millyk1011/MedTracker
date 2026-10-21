//
//  ContentView.swift
//  idk
//
//  Created by Milly Keene on 1/25/26.
//

import SwiftUI
import LocalAuthentication


struct AppColors {
    
    // Backgrounds
    static let background = Color(red: 248/255, green: 250/255, blue: 252/255)
    static let card = Color.white
    
    // Main Brand Color
    static let primary = Color(red: 67/255, green: 139/255, blue: 224/255)
    
    // Login Gradient
    static let gradientTop = Color(red: 248/255, green: 251/255, blue: 255/255)
    static let gradientMiddle = Color(red: 238/255, green: 246/255, blue: 255/255)
    static let gradientBottom = Color(red: 190/255, green: 220/255, blue: 255/255)
    
    // Accent
    static let accent = Color(red: 139/255, green: 201/255, blue: 181/255)
    
    // Text
    static let text = Color(red: 35/255, green: 55/255, blue: 78/255)
    static let secondaryText = Color(red: 105/255, green: 121/255, blue: 143/255)
    
    // Status
    static let success = Color(red: 91/255, green: 190/255, blue: 105/255)
    static let warning = Color(red: 240/255, green: 190/255, blue: 75/255)
    static let danger = Color(red: 220/255, green: 105/255, blue: 105/255)
}
    
    struct AppStyle {
    
        // MARK: - Fonts
    
        static let title = Font.system(size: 34, weight: .bold, design: .default)
    
        static let heading = Font.system(size: 24, weight: .semibold, design: .default)
    
        static let body = Font.system(size: 16, weight: .regular, design: .default)
    
        static let button = Font.system(size: 16, weight: .semibold, design: .default)
    
        static let caption = Font.system(size: 14, weight: .regular, design: .default)
}

    
    struct UserProfile: Codable {
        var name: String
        var age: String
        var medicalConditions: String
        var doctorInfo: String
    }
    
struct Medication: Codable, Identifiable {
    var id = UUID()
    var name: String
    var color: String
    var shape: String
    var dose: String
    var times: [Date]
    var takenToday: Bool = false
    var takenTimeIndices: [Int]? = []
}
    
    // MARK: - Welcome Screen
    
    struct ContentView: View {
        var body: some View {
            NavigationStack {
                ZStack {
                    AppColors.background                        .ignoresSafeArea()
                    LinearGradient(
                        stops: [
                            .init(color: AppColors.gradientTop, location: 0.0),
                            .init(color: AppColors.gradientMiddle, location: 0.45),
                            .init(color: AppColors.gradientBottom, location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottomLeading
                    )
                    .ignoresSafeArea()


                    
                    VStack(spacing: 40) {
                        Spacer()
                        
                        Text("Medication Tracker")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(AppColors.text)
                        
                        NavigationLink("Log In") {
                            LoginView()
                        }
                        .fontWeight(.semibold)
                        .frame(width: 220, height: 50)
                        .background(Color.white)
                        .foregroundColor(AppColors.primary)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                        
                        
                        
                        NavigationLink("Sign Up") {
                            SignUpView()
                        }
                        .fontWeight(.semibold)
                        .frame(width: 220, height: 50)
                        .background(Color.white)
                        .foregroundColor(AppColors.primary)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - Login / Create Account
    
struct LoginView: View {
    @State private var username = ""
    @State private var goToMain = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @FocusState private var loginNameFocused: Bool

    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: AppColors.gradientTop, location: 0.0),
                    .init(color: AppColors.gradientMiddle, location: 0.45),
                    .init(color: AppColors.gradientBottom, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 30) {
                Spacer()
                
                Text("Welcome")
                    .font(.system(size: 34, weight: .bold))
                    .font(AppStyle.heading)
                    .foregroundColor(AppColors.text)
                    .offset(y: -80)
                
                Text("Please log in to continue")
                    .font(AppStyle.heading)
                    .foregroundColor(AppColors.secondaryText)
                    .offset(y: -80)
                
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .padding(.horizontal, 30)

                    .focused($loginNameFocused)
                    .onAppear {
                        loginNameFocused = true
                    }
                
                VStack(spacing: 15) {
                    // Manual login
                    Button("Continue") {
                        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if cleanUsername.isEmpty {
                            alertMessage = "Please enter a username"
                            showAlert = true
                            
                        } else if UserDefaults.standard.data(forKey: "profile_\(cleanUsername)") == nil {
                            alertMessage = "Username not found. Please sign up first."
                            showAlert = true
                            
                        } else {
                            username = cleanUsername
                            UserDefaults.standard.set(cleanUsername, forKey: "currentUser")
                            goToMain = true
                        }
                    }
                    .frame(width: 250, height: 45)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(22)
                    
                    // Face ID login
                    Button("Continue with Face ID") {
                        authenticateWithFaceID()
                    }
                    .frame(width: 250, height: 45)
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(.blue)
                    .cornerRadius(22)
                }
                
                Spacer()
                
                // Navigation to MainView
                NavigationLink(
                    destination: MainView(username: username),
                    isActive: $goToMain
                ) { EmptyView() }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        // Check if device supports Face ID / Touch ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to access your medications"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        // ✅ Only proceed if a user exists
                        if let storedUser = UserDefaults.standard.string(forKey: "currentUser") {
                            username = storedUser
                            goToMain = true
                        } else {
                            alertMessage = "No previous user found. Please log in manually first."
                            showAlert = true
                        }
                    } else {
                        alertMessage = authError?.localizedDescription ?? "Authentication failed"
                        showAlert = true
                    }
                }
            }
        } else {
            alertMessage = "Face ID / Touch ID not available on this device"
            showAlert = true
        }
    }
}
    
    // MARK: - Home Page
    struct MainView: View {
        let username: String
        @State private var medications: [Medication] = []
    
        @State private var editingIndex: Int?
        @State private var showEditSheet = false
        @State private var toastMessage = ""
        @State private var showToast = false
        @State private var choosingTimeForMedication: Int?
        @State private var timeToUnmark: (medicationIndex: Int, timeIndex: Int)?
        
        
        
        var body: some View {
            ZStack {
                AppColors.background                        .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    
                    Text("Welcome, \(username)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(AppColors.text)
                    
                    let takenCount = medications.filter { $0.takenToday }.count
                    
                    Text("\(takenCount) of \(medications.count) medications taken today")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.secondaryText)
                    
                    
                    if medications.isEmpty {
                        VStack(spacing: 14) {
                            Image(systemName: "pills")
                                .font(.system(size: 48))
                                .foregroundStyle(AppColors.primary)
                            
                            Text("No medications yet")
                                .font(.headline)
                                .foregroundStyle(AppColors.text)
                            
                            Text("Add your first medication to begin tracking.")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.secondaryText)
                            
                            NavigationLink {
                                AddMedicationView(username: username)
                            } label: {
                                Label("Add Medication", systemImage: "plus")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 22)
                                    .padding(.vertical, 12)
                                    .background(AppColors.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    else {
                        List {
                            ForEach(medications.indices, id: \.self) { index in
                                let med = medications[index]
                                HStack(spacing: 12) {
                                    Image(systemName: med.takenToday ? "checkmark.circle.fill" : "pills.fill")
                                        .font(.title2)
                                        .foregroundStyle(med.takenToday ? AppColors.success : AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(med.name).font(.headline)
                                        Text(med.dose)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)

                                        ForEach(med.times.indices, id: \.self) { timeIndex in
                                            HStack(spacing: 5) {
                                                Text(formatTime(med.times[timeIndex]))

                                                if (med.takenTimeIndices ?? []).contains(timeIndex) {
                                                    Label("Taken", systemImage: "checkmark.circle.fill")
                                                        .foregroundStyle(AppColors.success)
                                                }
                                            }
                                            .font(.subheadline)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        editingIndex = index
                                        showEditSheet = true
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundStyle(AppColors.primary)
                                            .padding(8)
                                    }
                                    .buttonStyle(.borderless)
                                    
                                    Button {
                                        choosingTimeForMedication = index
                                    } label: {
                                        Image(
                                            systemName: (med.takenTimeIndices ?? []).count == med.times.count
                                                ? "checkmark"
                                                : "circle"
                                        )
                                        .font(.title2)
                                    }
                                    .accessibilityLabel(
                                        med.takenToday
                                        ? "Mark \(med.name) not taken"
                                        : "Mark \(med.name) taken"
                                    )
                                }
                                .padding(.vertical, 8)
                                .confirmationDialog(
                                    "Which time did you take?",
                                    isPresented: Binding(
                                        get: { choosingTimeForMedication == index },
                                        set: { if !$0 { choosingTimeForMedication = nil } }
                                    ),
                                    titleVisibility: .visible
                                ) {
                                    ForEach(medications[index].times.indices, id: \.self) { timeIndex in
                                        let alreadyTaken =
                                            (medications[index].takenTimeIndices ?? []).contains(timeIndex)

                                        Button("\(formatTime(medications[index].times[timeIndex]))\(alreadyTaken ? " (Taken)" : "")") {
                                            guard !alreadyTaken else { return }

                                            var taken = Set(medications[index].takenTimeIndices ?? [])
                                            taken.insert(timeIndex)
                                            medications[index].takenTimeIndices = Array(taken).sorted()
                                            medications[index].takenToday =
                                                taken.count == medications[index].times.count

                                            saveMedications()
                                        }
                                        .disabled(alreadyTaken)
                                    }

                                    Button("Cancel", role: .cancel) { }
                                }
                            }
                            .onDelete(perform: deleteMedication)
                        }
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                loadMedications()
                resetMedicationsIfNeeded()
            }
            .sheet(isPresented: $showEditSheet) {
                if let index = editingIndex,
                   medications.indices.contains(index) {
                    NavigationStack {
                        EditMedicationView(
                            medication: $medications[index],
                            onSave: {
                                saveMedications()
                                showToastMessage("Medication updated")
                            }
                        )
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink("Add Medication") {
                            AddMedicationView(username: username)
                        }

                        NavigationLink("Edit Profile") {
                            AccountView(username: username)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(AppColors.text)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if showToast {
                    Text(toastMessage)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(AppColors.success)
                        .clipShape(Capsule())
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: showToast)
        }
        
            
        
            
            
            func loadMedications() {
                if let data = UserDefaults.standard.data(forKey: "meds_\(username)"),
                   let decoded = try? JSONDecoder().decode([Medication].self, from: data) {
                    medications = decoded
                }
            }
            
            func saveMedications() {
                if let encoded = try? JSONEncoder().encode(medications) {
                    UserDefaults.standard.set(encoded, forKey: "meds_\(username)")
                }
            }
            
        func showToastMessage(_ message: String) {
            toastMessage = message
            showToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }
        
            func resetMedicationsIfNeeded() {
                let today = Calendar.current.startOfDay(for: Date())
                let savedDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date
                
                if savedDate == nil || !Calendar.current.isDate(savedDate!, inSameDayAs: today) {
                    for index in medications.indices {
                        medications[index].takenToday = false
                        medications[index].takenTimeIndices = []
                    }
                    
                    saveMedications()
                    UserDefaults.standard.set(today, forKey: "lastResetDate")
                }
            }
            
            func deleteMedication(at offsets: IndexSet) {
                medications.remove(atOffsets: offsets)
                saveMedications()
            }
            
            func formatTime(_ date: Date) -> String {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                return formatter.string(from: date)
            }
        }
        
    
    // MARK: - Add Medication
    
    struct AddMedicationView: View {
        let username: String
        
        @State private var name = ""
        @State private var color = ""
        @State private var shape = ""
        @State private var dose = ""
        @State private var times: [Date] = [Date()]
        @FocusState private var addNameFocused: Bool
        
        
        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Add Medication")
                        .font(.largeTitle)
                        .foregroundStyle(AppColors.text)
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .focused($addNameFocused)
                            .onAppear {
                                addNameFocused = true
                            }
                    
                    TextField("Color", text: $color)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Shape", text: $shape)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Dose", text: $dose)
                        .textFieldStyle(.roundedBorder)
                    
                    ForEach(times.indices, id: \.self) { index in
                        HStack {
                            DatePicker(
                                "Time \(index + 1)",
                                selection: $times[index],
                                displayedComponents: .hourAndMinute
                            )

                            if times.count > 1 {
                                Button(role: .destructive) {
                                    times.remove(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                            }
                        }
                    }
                    
                    Button("Add Another Time") {
                        times.append(Date())
                    }
                    
                    Button("Save Medication") {
                        saveMedication()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppColors.primary)
                }
                .padding()
                    
            }
        }
        
        func saveMedication() {
            let newMed = Medication(
                name: name,
                color: color,
                shape: shape,
                dose: dose,
                times: times
            )
            
            var meds = loadMedications()
            meds.append(newMed)
            
            if let encoded = try? JSONEncoder().encode(meds) {
                UserDefaults.standard.set(encoded, forKey: "meds_\(username)")
            }
            
        
        }
        
        
        
        
        func loadMedications() -> [Medication] {
            guard
                let data = UserDefaults.standard.data(forKey: "meds_\(username)"),
                let decoded = try? JSONDecoder().decode([Medication].self, from: data)
            else {
                return []
            }
            
            return decoded
        }
    }
    struct EditMedicationView: View {
        @Environment(\.dismiss) private var dismiss
        @FocusState private var editNameFocused: Bool
        @Binding var medication: Medication
        let onSave: () -> Void
        
        var body: some View {
            Form {
                Section("Medication Details") {
                    TextField("Name", text: $medication.name)
                        .focused($editNameFocused)
                            .onAppear {
                                editNameFocused = true
                            }
                    TextField("Color", text: $medication.dose)
                    TextField("Shape", text: $medication.color)
                    TextField("Dose", text: $medication.shape)
                }
                
                Section("Schedule") {
                    ForEach(medication.times.indices, id: \.self) { index in
                        HStack {
                            DatePicker(
                                "Time \(index + 1)",
                                selection: $medication.times[index],
                                displayedComponents: .hourAndMinute
                            )

                            if medication.times.count > 1 {
                                Button(role: .destructive) {
                                    medication.times.remove(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                            }
                        }
                    }
                    
                    Button("Add Another Time") {
                        medication.times.append(Date())
                    }
                }
                
            }
            .navigationTitle("Edit Medication")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(AppColors.primary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                    .foregroundStyle(AppColors.primary)
                }
            }
        }
    }
        // MARK: - Edit Profile Later
        
        struct SignUpView: View {
            @Environment(\.dismiss) private var dismiss
            
            @State private var username = ""
            @State private var name = ""
            @State private var age = ""
            @State private var medicalConditions = ""
            @State private var doctorInfo = ""
            
            @State private var showAlert = false
            @FocusState private var usernameFocused: Bool
            
            var body: some View {
                Form {
                    Section("Create Login") {
                        TextField("Login Name", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .focused($usernameFocused)
                            .onAppear {
                                usernameFocused = true
                            }
                    }
                    
                    Section("Your Profile") {
                        TextField("Full Name", text: $name)
                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                        TextField("Medical Conditions", text: $medicalConditions)
                        TextField("Doctor Information", text: $doctorInfo)
                    }
                    
                    Button("Create Account") {
                        createAccount()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .listRowBackground(AppColors.primary)
                }
                .navigationTitle("Create Account")
                .alert("Enter a login name", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
            
            func createAccount() {
                let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard !cleanUsername.isEmpty else {
                    showAlert = true
                    return
                }
                
                let profile = UserProfile(
                    name: name,
                    age: age,
                    medicalConditions: medicalConditions,
                    doctorInfo: doctorInfo
                )
                
                if let encoded = try? JSONEncoder().encode(profile) {
                    UserDefaults.standard.set(encoded, forKey: "profile_\(cleanUsername)")
                }
                
                UserDefaults.standard.set(cleanUsername, forKey: "currentUser")
                dismiss()
            }
        }
        
        struct AccountView: View {
            let username: String
            
            @State private var name = ""
            @State private var age = ""
            @State private var medicalConditions = ""
            @State private var doctorInfo = ""
            
            var body: some View {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Edit Profile")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        
                        TextField("Full Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Age", text: $age)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Medical Conditions", text: $medicalConditions)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Doctor Info", text: $doctorInfo)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Save Changes") {
                            saveProfile()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppColors.primary)
                    }
                    .padding()
                }
                .onAppear { loadProfile() }
            }
            
            func saveProfile() {
                let profile = UserProfile(
                    name: name,
                    age: age,
                    medicalConditions: medicalConditions,
                    doctorInfo: doctorInfo
                )
                
                if let encoded = try? JSONEncoder().encode(profile) {
                    UserDefaults.standard.set(encoded, forKey: "profile_\(username)")
                }
            }
            
            func loadProfile() {
                if let data = UserDefaults.standard.data(forKey: "profile_\(username)"),
                   let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
                    name = decoded.name
                    age = decoded.age
                    medicalConditions = decoded.medicalConditions
                    doctorInfo = decoded.doctorInfo
                }
            }
        }
    

            




