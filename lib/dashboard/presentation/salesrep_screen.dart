import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_reimbursement/auth/presentation/login_screen.dart';
import 'package:travel_reimbursement/auth/service/auth_service.dart';
import 'package:travel_reimbursement/dashboard/controller/travel_provider.dart';
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';
import 'package:travel_reimbursement/dashboard/presentation/newreqlist_screen.dart';

class RepScreen extends StatefulWidget {
  const RepScreen({super.key});

  @override
  State<RepScreen> createState() => _RepScreenState();
}

class _RepScreenState extends State<RepScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    
    // Fetch requests when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TravelProvider>();
      provider.fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TravelProvider>();
    final pending = provider.pendingRequests;
    final paid = provider.paidRequests;

    if (provider.error != null && provider.requests.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "Error Loading Data",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  provider.error ?? "Unknown error occurred",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.fetchRequests(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Retry",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.isLoading && provider.requests.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: _buildAppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: _buildContent(provider, pending, paid),
      floatingActionButton: _currentIndex == 0 && !provider.isLoading
          ? FloatingActionButton(
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add, color: Colors.white),
                onPressed: () =>_showAddRequestDialog(context, provider)):null
                );
  }

  AppBar _buildAppBar() {
    final provider = context.read<TravelProvider>();
    final pending = provider.pendingRequests;
    final paid = provider.paidRequests;

    return AppBar(
      title: const Text(
        "Sales Dashboard",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.teal,
      actions: [
        if (provider.isLoading)
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => provider.fetchRequests(),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            await AuthService.logout();
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                // Pending Toggle
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                        _tabController.animateTo(0);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentIndex == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Pending (${pending.length})",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _currentIndex == 0
                                ? Colors.teal
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Approved/Paid Toggle
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                        _tabController.animateTo(1);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentIndex == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Approved (${paid.length})",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _currentIndex == 1
                                ? Colors.teal
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(TravelProvider provider, List<TravelRequest> pending, List<TravelRequest> paid) {
    final currentList = _currentIndex == 0 ? pending : paid;

    if (currentList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _currentIndex == 0 ? Icons.hourglass_empty : Icons.check_circle_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _currentIndex == 0 ? "No Pending Requests" : "No Approved Requests",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentIndex == 0
                  ? "Add a new request using the + button"
                  : "Your approved requests will appear here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchRequests(),
      color: Colors.teal,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: currentList.length,
        itemBuilder: (_, i) {
          final req = currentList[i];
          return _buildRequestItem(req, provider);
        },
      ),
    );
  }

  Widget _buildRequestItem(TravelRequest req, TravelProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: req.status.toLowerCase() == "pending"
                ? Colors.orange.shade100
                : Colors.green.shade100,
            width: 1.5,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: req.status.toLowerCase() == "pending"
                  ? Colors.orange.shade50
                  : Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              req.status.toLowerCase() == "pending" ? Icons.pending : Icons.check_circle,
              color: req.status.toLowerCase() == "pending" ? Colors.orange : Colors.green,
            ),
          ),
          title: Text(
            req.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: req.status.toLowerCase() == "pending"
                  ? Colors.orange.shade800
                  : Colors.green.shade800,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.route,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${req.km} KM",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                req.timestamp.toLocal().toString().split('.')[0],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: req.status.toLowerCase() == "pending"
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: req.status.toLowerCase() == "pending"
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                  ),
                ),
                child: Text(
                  req.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: req.status.toLowerCase() == "pending"
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
                  ),
                ),
              ),
              if (req.status.toLowerCase() == "pending")
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'approve') {
                      provider.updateRequestStatus(req.id, 'paid');
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(req.id, provider);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'approve',
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Approve'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddRequestDialog(BuildContext context, TravelProvider provider) {
    _nameController.clear();
    _kmController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Text(
                    "New Travel Request",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Client Name",
                  prefixIcon: Icon(Icons.person, color: Colors.teal),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _kmController,
                decoration: const InputDecoration(
                  labelText: "KM",
                  prefixIcon: Icon(Icons.route, color: Colors.teal),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          // Validate inputs
                          if (_nameController.text.trim().isEmpty || _kmController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          final km = int.tryParse(_kmController.text.trim());
                          if (km == null || km <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a valid KM value"),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          // Call provider to add request
                        final success = await provider.addRequest(
  _nameController.text.trim(),
  km,
);

if (!context.mounted) return;

if (success) {
  Navigator.pop(bottomSheetContext);
  provider.fetchRequests();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Request added successfully!"),
      backgroundColor: Colors.green,
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(provider.error ?? "Something went wrong"),
      backgroundColor: Colors.red,
    ),);}},

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Submit Request",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String id, TravelProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Request"),
        content: const Text("Are you sure you want to delete this request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await provider.deleteRequest(id);
              
              if (!context.mounted) return;
              
              if (provider.error == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Request deleted successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: ${provider.error}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _kmController.dispose();
    super.dispose();
  }
}