import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/app_theme.dart';
import '../../../../models/call_data.dart';
import '../../../../utils/formatters.dart';

class CallHistoryCard extends StatelessWidget {
  const CallHistoryCard({
    super.key,
    required this.callData,
    this.onTap,
  });

  final CallData callData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap ?? () {
          context.push('/call-details/${callData.callSid}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Call Direction & Status Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getDirectionIcon(),
                  color: _getStatusColor(),
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Call Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          Formatters.formatPhoneNumber(callData.phoneNumber),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            callData.status.displayName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppTheme.subtleTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.formatRelativeTime(callData.startTime),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.subtleTextColor,
                          ),
                        ),
                        if (callData.duration != null) ...[
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.timer,
                            size: 14,
                            color: AppTheme.subtleTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Formatters.formatDurationWords(callData.duration!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.subtleTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    // Show call preview/notes if available
                    if (callData.notes?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Text(
                        callData.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textColor.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Action Indicators
              Column(
                children: [
                  if (callData.recordingUrl != null)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.audiotrack,
                        size: 14,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  
                  if (callData.transcript != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.description,
                        size: 14,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                  
                  if (callData.entities.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        size: 14,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  
                  const Icon(
                    Icons.chevron_right,
                    color: AppTheme.subtleTextColor,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (callData.status) {
      case CallStatus.completed:
        return Colors.green;
      case CallStatus.inProgress:
        return Colors.blue;
      case CallStatus.failed:
      case CallStatus.noAnswer:
        return Colors.red;
      case CallStatus.busy:
        return Colors.orange;
      case CallStatus.canceled:
        return AppTheme.subtleTextColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getDirectionIcon() {
    if (callData.direction == CallDirection.inbound) {
      switch (callData.status) {
        case CallStatus.completed:
          return Icons.call_received;
        case CallStatus.noAnswer:
        case CallStatus.failed:
          return Icons.call_received;
        default:
          return Icons.call_received;
      }
    } else {
      switch (callData.status) {
        case CallStatus.completed:
          return Icons.call_made;
        case CallStatus.noAnswer:
        case CallStatus.failed:
          return Icons.call_made;
        default:
          return Icons.call_made;
      }
    }
  }
}
